#import "FGFactoryDefinition.h"
#import "FGFieldDefinition.h"

@implementation FGFactoryDefinition

- (instancetype)initWithInitializerDefinition:(FGInitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSArray *)fieldDefinitions
{
    self = [super init];
    if (self) {
        NSParameterAssert(fieldDefinitions);
        _initializerDefinition = initializerDefinition;
        _fieldDefinitions = fieldDefinitions;
    }
    return self;
}

- (instancetype)mergedWithDefinition:(FGFactoryDefinition *)otherDefinition
{
    FGInitializerDefinition *initializerDefinition = [self mergedInitializerDefinitionWith:otherDefinition.initializerDefinition];
    NSArray *fieldDefinitions = [self mergedFieldDefinitionsWith:otherDefinition.fieldDefinitions];
    return [[FGFactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                     fieldDefinitions:fieldDefinitions];
}

- (FGInitializerDefinition *)mergedInitializerDefinitionWith:(FGInitializerDefinition *)otherInitializerDefinition
{
    if (otherInitializerDefinition) {
        return otherInitializerDefinition;
    } else {
        return self.initializerDefinition;
    }
}

- (NSArray *)mergedFieldDefinitionsWith:(NSArray *)otherFieldDefinitions
{
    NSSet *mergedDefinitions = [[NSSet setWithArray:otherFieldDefinitions] setByAddingObjectsFromArray:self.fieldDefinitions];
    return [mergedDefinitions allObjects];
}

- (NSArray *)initializerFieldDefinitions
{
    NSMutableArray *initializerFieldDefinitions = [[NSMutableArray alloc] init];
    for (FGFieldDefinition *fieldDefinition in self.fieldDefinitions) {
        if ([self.initializerDefinition.fieldNames containsObject:fieldDefinition.name]) {
            [initializerFieldDefinitions addObject:fieldDefinition];
        }
    }
    return initializerFieldDefinitions;
}

- (NSArray *)setterFieldDefinitions
{
    NSMutableArray *setterFieldDefinitions = [[NSMutableArray alloc] init];
    for (FGFieldDefinition *fieldDefinition in self.fieldDefinitions) {
        if (![self.initializerDefinition.fieldNames containsObject:fieldDefinition.name]) {
            [setterFieldDefinitions addObject:fieldDefinition];
        }
    }
    return setterFieldDefinitions;
}

@end
