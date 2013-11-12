#import "ObjectBuilder.h"

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
    return [self buildWithFields:@{}];
}

- (id)buildWithFields:(NSDictionary *)fields
{
    id object = [[self.objectClass alloc] init];
    [self setFieldEvaluatorsOnObject:object];
    [self setFields:fields
           onObject:object];
    return object;
}

- (void)setFieldEvaluatorsOnObject:(id)object
{
    for (NSString *field in self.definition.fieldDefinitions) {
        id (^evaluator)(void) = self.definition.fieldDefinitions[field];
        [self setField:field
                 value:evaluator()
              onObject:object];
    }
}

- (void)setFields:(NSDictionary *)fields
         onObject:(id)object
{
    [fields enumerateKeysAndObjectsUsingBlock:^(NSString *field, id value, BOOL *stop) {
        [self setField:field
                 value:value
              onObject:object];
    }];
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
