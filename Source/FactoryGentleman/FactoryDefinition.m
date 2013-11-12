#import "FactoryDefinition.h"

@implementation FactoryDefinition

- (instancetype)initWithFieldDefinitions:(NSDictionary *)fieldDefinitions
{
    self = [super init];
    if (self) {
        NSParameterAssert(fieldDefinitions);
        _fieldDefinitions = fieldDefinitions;
    }
    return self;
}

@end
