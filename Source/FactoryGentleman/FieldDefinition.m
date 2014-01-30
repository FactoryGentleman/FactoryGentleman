#import "FieldDefinition.h"

@implementation FieldDefinition

+ (instancetype)withFieldName:(NSString *)name definition:(id (^)())definition
{
    return [[FieldDefinition alloc] initWithFieldName:name definition:definition];
}

- (id)initWithFieldName:(NSString *)fieldName definition:(id (^)())definition
{
    self = [super init];
    if (self) {
        NSParameterAssert(fieldName);
        NSParameterAssert(definition);
        _name = fieldName;
        _definition = definition;
    }
    return self;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self.name isEqualToString:[other name]];
}

- (NSUInteger)hash
{
    return [self.name hash];
}

@end
