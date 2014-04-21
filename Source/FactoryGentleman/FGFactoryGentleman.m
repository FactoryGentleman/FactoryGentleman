#import "FactoryGentleman.h"

#import "FGObjectBuilder.h"
#import "FGFactoryDefinitionRegistry.h"

@implementation FGFactoryGentleman

+ (id)buildForObjectClass:(Class)objectClass
{
    NSParameterAssert(objectClass);
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:baseDefinition] build];
}

+ (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait
{
    NSParameterAssert(objectClass);
    NSParameterAssert(trait);
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *traitDefinition = [self definitionForObjectClass:objectClass
                                                                    trait:trait];
    FGFactoryDefinition *finalDefinition = [baseDefinition mergedWithDefinition:traitDefinition];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:finalDefinition] build];
}

+ (id)buildForObjectClass:(Class)objectClass
       withFactoryDefiner:(void (^)(FGDefinitionBuilder *))factoryDefiner
{
    NSParameterAssert(objectClass);
    NSParameterAssert(factoryDefiner);
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *overriddenDefinition = [self overriddenDefinitionFromDefiner:factoryDefiner];
    FGFactoryDefinition *finalDefinition = [baseDefinition mergedWithDefinition:overriddenDefinition];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:finalDefinition] build];
}

+ (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait
       withFactoryDefiner:(void (^)(FGDefinitionBuilder *))factoryDefiner
{
    NSParameterAssert(objectClass);
    NSParameterAssert(trait);
    NSParameterAssert(factoryDefiner);
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *traitDefinition = [self definitionForObjectClass:objectClass
                                                                    trait:trait];
    FGFactoryDefinition *overriddenDefinition = [self overriddenDefinitionFromDefiner:factoryDefiner];
    FGFactoryDefinition *finalDefinition = [[baseDefinition mergedWithDefinition:traitDefinition]
            mergedWithDefinition:overriddenDefinition];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:finalDefinition] build];
}

+ (FGFactoryDefinition *)definitionForObjectClass:(Class)objectClass
{
    FGFactoryDefinition *factoryDefinition = [[FGFactoryDefinitionRegistry sharedInstance] 
            factoryDefinitionForObjectClass:objectClass];
    NSAssert(factoryDefinition, @"No definition found for class %@", objectClass);
    return factoryDefinition;
}

+ (FGFactoryDefinition *)definitionForObjectClass:(Class)objectClass
                                            trait:(NSString *)trait
{
    FGFactoryDefinition *factoryDefinition = [[FGFactoryDefinitionRegistry sharedInstance]
            factoryDefinitionForObjectClass:objectClass
                                      trait:trait];
    NSAssert(factoryDefinition, @"No definition found for class %@ with trait %@", objectClass, trait);
    return factoryDefinition;
}

+ (FGFactoryDefinition *)overriddenDefinitionFromDefiner:(void (^)(FGDefinitionBuilder *))factoryDefiner
{
    FGDefinitionBuilder *builder = [FGDefinitionBuilder builder];
    factoryDefiner(builder);
    FGFactoryDefinition *overriddenDefinition = [builder build];
    return overriddenDefinition;
}

@end
