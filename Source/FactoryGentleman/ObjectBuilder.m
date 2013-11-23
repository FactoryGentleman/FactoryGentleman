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

- (id)buildWithFieldDefinitions:(NSDictionary *)fieldDefinitions
{
    id object = [[self.objectClass alloc] init];
    [self setFieldDefinitions:self.definition.fieldDefinitions
                     onObject:object];
    [self setFieldDefinitions:fieldDefinitions
                     onObject:object];
    return object;
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
