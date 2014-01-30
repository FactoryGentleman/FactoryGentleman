#import "FactoryDefinition.h"
#import "FieldDefinition.h"

@implementation FactoryDefinition

- (instancetype)initWithInitializerDefinition:(InitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSArray *)fieldDefinitions;
{
    self = [super init];
    if (self) {
        NSParameterAssert(fieldDefinitions);
        _initializerDefinition = initializerDefinition;
        _fieldDefinitions = fieldDefinitions;
    }
    return self;
}

- (instancetype)mergedWithDefinition:(FactoryDefinition *)otherDefinition
{
    InitializerDefinition *initializerDefinition = [self mergedInitializerDefinitionWith:otherDefinition.initializerDefinition];
    NSArray *fieldDefinitions = [self mergedFieldDefinitionsWith:otherDefinition.fieldDefinitions];
    return [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                   fieldDefinitions:fieldDefinitions];
}

- (InitializerDefinition *)mergedInitializerDefinitionWith:(InitializerDefinition *)otherInitializerDefinition
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
    for (FieldDefinition *fieldDefinition in self.fieldDefinitions) {
        if ([self.initializerDefinition.fieldNames containsObject:fieldDefinition.name]) {
            [initializerFieldDefinitions addObject:fieldDefinition];
        }
    }
    return initializerFieldDefinitions;
}

- (NSArray *)setterFieldDefinitions
{
    NSMutableArray *setterFieldDefinitions = [[NSMutableArray alloc] init];
    for (FieldDefinition *fieldDefinition in self.fieldDefinitions) {
        if (![self.initializerDefinition.fieldNames containsObject:fieldDefinition.name]) {
            [setterFieldDefinitions addObject:fieldDefinition];
        }
    }
    return setterFieldDefinitions;
}

@end
