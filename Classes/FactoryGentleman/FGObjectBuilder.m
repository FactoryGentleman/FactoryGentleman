#import "FGObjectBuilder.h"

#import "FGValue.h"
#import "FGNilValue.h"
#import "FGFieldHelper.h"

@implementation FGObjectBuilder

- (instancetype)initWithObjectClass:(Class)objectClass
                           readonly:(BOOL)readonly
                         definition:(FGFactoryDefinition *)definition
{
    self = [super init];
    if (self) {
        NSParameterAssert(objectClass);
        NSParameterAssert(definition);
        _objectClass = objectClass;
        _readonly = readonly;
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
    NSMethodSignature *methodSignature = [constructor methodSignatureForSelector:[self definitionSelector]];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];

    [inv setSelector:[self definitionSelector]];
    [inv setTarget:constructor];

    NSMutableArray *arguments = [NSMutableArray array];
    NSUInteger index = 2;
    for (FGFieldDefinition fieldDefinition in [self.definition initializerFieldDefinitions]) {
        if (![[NSNull null] isEqual:fieldDefinition]) {
            id value = fieldDefinition();
            [arguments addObject:value];

            if ([value isKindOfClass:[FGValue class]]) {
                [self setValueFromValue:value
                                  index:index
                             invocation:inv];
            } else if (value && ![value isKindOfClass:[FGNilValue class]]) {
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

- (SEL)definitionSelector
{
    return self.definition.initializerDefinition.selector ? self.definition.initializerDefinition.selector : @selector(init);
}

- (void)setFieldDefinitionsOnObject:(id)object
{
    NSDictionary *setterFieldDefinitions = [self.definition setterFieldDefinitions];
    for (NSString *setterFieldName in setterFieldDefinitions) {
        [self setField:setterFieldName
                 value:setterFieldDefinitions[setterFieldName]
              onObject:object];
    }
}

- (void)setField:(NSString *)field
           value:(id (^)())fieldDefinition
        onObject:(id)object
{
    if (fieldDefinition) {
        id fieldValue = fieldDefinition();
        NSInvocation *invocation = [self setterInvocationForField:field
                                                         onObject:object];
        if (invocation) {
            if ([fieldValue isKindOfClass:[FGValue class]]) {
                [self setValueFromValue:fieldValue
                                  index:2
                             invocation:invocation];
            } else if (fieldValue && ![fieldValue isKindOfClass:[FGNilValue class]]) {
                [invocation setArgument:&fieldValue
                                atIndex:2];
            }

            [invocation invoke];
        } else if (self.readonly) {
            @try {
                if ([fieldValue isKindOfClass:[FGValue class]]) {
                    [object setValue:[fieldValue wrappedValue]
                              forKey:field];
                } else if (fieldValue && ![fieldValue isKindOfClass:[FGNilValue class]]) {
                    [object setValue:fieldValue
                              forKey:field];
                }
            } @catch (NSException *e) {}
        }
    }
}

- (NSInvocation *)setterInvocationForField:(NSString *)field
                                  onObject:(id)object
{
    return [self invocationForSetter:[FGFieldHelper setterForField:field]
                            onObject:object];
}

- (NSInvocation *)invocationForSetter:(SEL)setter
                             onObject:(id)object
{
    NSMethodSignature *methodSignature = [object methodSignatureForSelector:setter];
    if (methodSignature) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:methodSignature];
        [inv setSelector:setter];
        [inv setTarget:object];
        return inv;
    } else {
        return nil;
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

@end
