#import "FactoryDefinition.h"

@implementation FactoryDefinition

- (instancetype)initWithInitializerDefinition:(InitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSDictionary *)fieldDefinitions;
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
    NSDictionary *fieldDefinitions = [self mergedFieldDefinitionsWith:otherDefinition.fieldDefinitions];
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

- (NSDictionary *)mergedFieldDefinitionsWith:(NSDictionary *)otherFieldDefinitions
{
    NSMutableDictionary *combinedFieldDefinitions = [self.fieldDefinitions mutableCopy];
    [combinedFieldDefinitions addEntriesFromDictionary:otherFieldDefinitions];
    return combinedFieldDefinitions;
}

- (NSDictionary *)initializerFieldDefinitions
{
    NSMutableDictionary *initializerFieldDefinitions = [[NSMutableDictionary alloc] init];
    for (NSString *fieldName in self.fieldDefinitions) {
        if ([self.initializerDefinition.fieldNames containsObject:fieldName]) {
            initializerFieldDefinitions[fieldName] = self.fieldDefinitions[fieldName];
        }
    }
    return initializerFieldDefinitions;
}

- (NSDictionary *)setterFieldDefinitions
{
    NSMutableDictionary *setterFieldDefinitions = [[NSMutableDictionary alloc] init];
    for (NSString *fieldName in self.fieldDefinitions) {
        if (![self.initializerDefinition.fieldNames containsObject:fieldName]) {
            setterFieldDefinitions[fieldName] = self.fieldDefinitions[fieldName];
        }
    }
    return setterFieldDefinitions;
}

@end
