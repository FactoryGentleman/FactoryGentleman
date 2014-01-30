#import "ObjectBuilder.h"

#import <objc/message.h>

#import "Value.h"
#import "FieldDefinition.h"

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

    NSArray *initializerFieldDefinitions = [self.definition initializerFieldDefinitions];
    NSUInteger index = 2;
    for (FieldDefinition *fieldDefinition in initializerFieldDefinitions) {
        id (^definition)(void) = fieldDefinition.definition;
        if (definition) {
            id value = definition();
            if ([value isKindOfClass:Value.class]) {
                [self setValueFromValue:value
                                  index:index
                             invocation:inv];
            } else if (value) {
                [inv setArgument:&value atIndex:index];
            }
        }
        index++;
    }

    [inv invoke];

    return alloced;
}

- (void)setFieldDefinitionsOnObject:(id)object
{
    for (FieldDefinition *fieldDefinition in [self.definition setterFieldDefinitions]) {
        [self setField:fieldDefinition.name
                 value:fieldDefinition.definition
              onObject:object];
    }
}

- (void)setField:(NSString *)field
           value:(id (^)())fieldDefinition
        onObject:(id)object
{
    SEL setter = [self setterForField:field];
    NSMethodSignature *methodSignature = [object methodSignatureForSelector:setter];
    if (methodSignature && fieldDefinition) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];
        [inv setSelector:setter];
        [inv setTarget:object];

        id fieldValue = fieldDefinition();
        if ([fieldValue isKindOfClass:Value.class]) {
            [self setValueFromValue:fieldValue
                              index:2
                         invocation:inv];
        } else if (fieldValue) {
            [inv setArgument:&fieldValue atIndex:2];
        }

        [inv invoke];
    }
}

- (void)setValueFromValue:(Value *)value
                    index:(NSUInteger)index
               invocation:(NSInvocation *)inv
{
    NSUInteger size;
    const char *type = [[value wrappedValue] objCType];
    NSGetSizeAndAlignment(type, &size, NULL);
    void *actualValue = malloc(size);
    [[value wrappedValue] getValue:actualValue];
    [inv setArgument:actualValue atIndex:index];
    free(actualValue);
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
