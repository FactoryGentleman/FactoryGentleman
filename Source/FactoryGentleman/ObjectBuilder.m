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

- (id)build
{
    id object = [self createObjectInstance];
    [self setFieldDefinitionsOnObject:object];
    return object;
}

- (id)createObjectInstance
{
    __strong id alloced = [self.objectClass alloc];

    NSMethodSignature *methodSignature = [alloced methodSignatureForSelector:self.definition.initializerDefinition.selector];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];

    [inv setSelector:self.definition.initializerDefinition.selector];
    [inv setTarget:alloced];

    NSArray *initializerFields = [self evaluatedFieldsFromDefinitions:[self.definition initializerFieldDefinitions]];
    [initializerFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    for (NSString *fieldName in fieldDefinitions) {
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

- (void)setFieldDefinitionsOnObject:(id)object
{
    for (NSString *fieldName in [self.definition setterFieldDefinitions]) {
        id (^definition)(void) = [self.definition setterFieldDefinitions][fieldName];
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
