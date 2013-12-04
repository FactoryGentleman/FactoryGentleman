#import "FactoryDefinition.h"

@implementation FactoryDefinition

- (instancetype)initWithInitializerDefinition:(InitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSDictionary *)fieldDefinitions;
{
    self = [super init];
    if (self) {
        NSParameterAssert(initializerDefinition);
        NSParameterAssert(fieldDefinitions);
        _initializerDefinition = initializerDefinition;
        _fieldDefinitions = fieldDefinitions;
    }
    return self;
}

@end
