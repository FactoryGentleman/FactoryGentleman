#import "FactoryDefinition.h"

@implementation FactoryDefinition

- (instancetype)initWithFields:(NSDictionary *)fields
{
    self = [super init];
    if (self) {
        NSParameterAssert(fields);
        _fields = fields;
    }
    return self;
}

@end
