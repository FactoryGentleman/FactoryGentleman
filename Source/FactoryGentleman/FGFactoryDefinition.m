#import "FGFactoryDefinition.h"

@implementation FGFactoryDefinition

- (instancetype)initWithInitializerDefinition:(FGInitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSDictionary *)fieldDefinitions
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
    NSDictionary *fieldDefinitions = [self mergedFieldDefinitionsWith:otherDefinition.fieldDefinitions];
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

- (NSDictionary *)mergedFieldDefinitionsWith:(NSDictionary *)otherFieldDefinitions
{
    NSMutableDictionary *mergedFieldDefinitions = [self.fieldDefinitions mutableCopy];
    [mergedFieldDefinitions addEntriesFromDictionary:otherFieldDefinitions];
    return [mergedFieldDefinitions copy];
}

- (NSOrderedSet *)initializerFieldDefinitions
{
    NSMutableOrderedSet *initializerFieldDefinitions = [[NSMutableOrderedSet alloc] init];
    for (NSString *initializerFieldName in self.initializerDefinition.fieldNames) {
        id initializerDefinition = [self.fieldDefinitions objectForKey:initializerFieldName];
        if (initializerDefinition) {
            [initializerFieldDefinitions addObject:initializerDefinition];
        } else {
            [initializerFieldDefinitions addObject:[NSNull null]];
        }
    }
    return initializerFieldDefinitions;
}

- (NSDictionary *)setterFieldDefinitions
{
    NSMutableDictionary *setterFieldDefinitions = [[NSMutableDictionary alloc] init];
    for (NSString *fieldName in self.fieldDefinitions) {
        if (![self.initializerDefinition.fieldNames containsObject:fieldName]) {
            [setterFieldDefinitions setObject:[self.fieldDefinitions objectForKey:fieldName] forKey:fieldName];
        }
    }
    return setterFieldDefinitions;
}

@end
