#import "ObjectBuilder.h"

#import <objc/message.h>

@implementation ObjectBuilder

- (instancetype)initWithObjectClass:(Class)objectClass
                         definition:(FactoryDefinition *)definition
{
    self = [super init];
    if (self) {
        NSParameterAssert(objectClass);
        NSParameterAssert(definition);
        _objectClass = objectClass;
        _definition = definition;
    }
    return self;
}

- (id)buildWithFieldDefinitions:(NSDictionary *)fieldDefinitions
{

    id object = [self createObjectInstanceWithFieldDefinitions:[self initializerFieldDefinitionsWith:fieldDefinitions]];
    [self setFieldDefinitions:[self setterFieldDefinitionsWith:fieldDefinitions]
                     onObject:object];

    return object;
}

- (id)createObjectInstanceWithFieldDefinitions:(NSDictionary *)fieldDefinitions
{
    __strong id alloced = [self.objectClass alloc];

    NSMethodSignature *methodSignature = [alloced methodSignatureForSelector:self.definition.initializerDefinition.selector];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];

    [inv setSelector:self.definition.initializerDefinition.selector];
    [inv setTarget:alloced];

    [[self evaluatedFieldsFromDefinitions:fieldDefinitions] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != self.nilObject) {
            [inv setArgument:&obj atIndex:idx + 2];
        }
    }];

    [inv invoke];

    return alloced;
}

- (NSArray *)evaluatedFieldsFromDefinitions:(NSDictionary *)fieldDefinitions
{
    NSMutableArray *evaluatedFields = [[NSMutableArray alloc] init];
    for (NSString *fieldName in self.definition.initializerDefinition.fieldNames) {
        id (^definition)(void) = fieldDefinitions[fieldName];
        if (definition) {
            id value = definition();
            if (value) {
                [evaluatedFields addObject:value];
            } else {
                [evaluatedFields addObject:self.nilObject];
            }
        } else {
            [evaluatedFields addObject:self.nilObject];
        }
    }
    return evaluatedFields;
}

- (id)nilObject
{
    static dispatch_once_t once;
    static id nilObject;
    dispatch_once(&once, ^{
        nilObject = [[NSObject alloc] init];
    });
    return nilObject;
}

- (NSDictionary *)initializerFieldDefinitionsWith:(NSDictionary *)fieldDefinitions
{
    NSDictionary *combinedFieldDefinitions = [self combinedFieldDefinitionsWith:fieldDefinitions];
    NSMutableDictionary *initializerFieldDefinitions = [[NSMutableDictionary alloc] init];
    for (NSString *fieldName in combinedFieldDefinitions) {
        if ([self.definition.initializerDefinition.fieldNames containsObject:fieldName]) {
            initializerFieldDefinitions[fieldName] = combinedFieldDefinitions[fieldName];
        }
    }
    return initializerFieldDefinitions;
}

- (NSDictionary *)setterFieldDefinitionsWith:(NSDictionary *)fieldDefinitions
{
    NSDictionary *combinedFieldDefinitions = [self combinedFieldDefinitionsWith:fieldDefinitions];
    NSMutableDictionary *setterFieldDefinitions = [[NSMutableDictionary alloc] init];
    for (NSString *fieldName in combinedFieldDefinitions) {
        if (![self.definition.initializerDefinition.fieldNames containsObject:fieldName]) {
            setterFieldDefinitions[fieldName] = combinedFieldDefinitions[fieldName];
        }
    }
    return setterFieldDefinitions;
}

- (NSDictionary *)combinedFieldDefinitionsWith:(NSDictionary *)fieldDefinitions
{
    NSMutableDictionary *combinedFieldDefinitions = [self.definition.fieldDefinitions mutableCopy];
    [combinedFieldDefinitions addEntriesFromDictionary:fieldDefinitions];
    return combinedFieldDefinitions;
}

- (void)setFieldDefinitions:(NSDictionary *)fieldDefinitions
                   onObject:(id)object
{
    for (NSString *fieldName in fieldDefinitions) {
        id (^definition)(void) = fieldDefinitions[fieldName];
        [self setField:fieldName
                 value:definition()
              onObject:object];
    }
}

- (void)setField:(NSString *)field
           value:(id)value
        onObject:(id)object
{
    SEL setter = [self setterForField:field];
    if ([object respondsToSelector:setter]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [object performSelector:setter
                     withObject:value];
        #pragma clang diagnostic pop
    }
}

- (SEL)setterForField:(NSString *)field
{
    NSString *setterString = [NSString stringWithFormat:@"set%@:", [self camelcaseForField:field]];
    return NSSelectorFromString(setterString);
}

- (NSString *)camelcaseForField:(NSString *)field
{
    return [field stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                          withString:[[field  substringToIndex:1] capitalizedString]];
}

@end
