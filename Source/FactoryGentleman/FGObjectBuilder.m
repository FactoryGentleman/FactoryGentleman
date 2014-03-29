#import "FGObjectBuilder.h"

#import "FGValue.h"

@implementation FGObjectBuilder

- (instancetype)initWithObjectClass:(Class)objectClass
                         definition:(FGFactoryDefinition *)definition
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
    id object = [self createObjectInstanceWithConstructor:[self objectConstructor]];
    [self setFieldDefinitionsOnObject:object];
    return object;
}

- (id)objectConstructor
{
    if (self.definition.constructor) {
        return self.definition.constructor;
    } else {
        __autoreleasing id constructor = [self.objectClass alloc];
        return constructor;
    }
}

- (id)createObjectInstanceWithConstructor:(id)constructor
{
    NSMethodSignature *methodSignature = [constructor methodSignatureForSelector:self.definition.initializerDefinition.selector];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];

    [inv setSelector:self.definition.initializerDefinition.selector];
    [inv setTarget:constructor];

    NSUInteger index = 2;
    for (FGFieldDefinition fieldDefinition in [self.definition initializerFieldDefinitions]) {
        if (![[NSNull null] isEqual:fieldDefinition]) {
            id value = fieldDefinition();
            if ([value isKindOfClass:[FGValue class]]) {
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
    __autoreleasing id object;
    [inv getReturnValue:&object];

    return object;
}

- (void)setFieldDefinitionsOnObject:(id)object
{
    NSDictionary *setterFieldDefinitions = [self.definition setterFieldDefinitions];
    for (NSString *setterFieldName in setterFieldDefinitions) {
        [self setField:setterFieldName
                 value:[setterFieldDefinitions objectForKey:setterFieldName]
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
        if ([fieldValue isKindOfClass:[FGValue class]]) {
            [self setValueFromValue:fieldValue
                              index:2
                         invocation:inv];
        } else if (fieldValue) {
            [inv setArgument:&fieldValue atIndex:2];
        }

        [inv invoke];
    }
}

- (void)setValueFromValue:(FGValue *)value
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
    return [field stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                          withString:[[field substringToIndex:1] capitalizedString]];
}

@end
