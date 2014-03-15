#import "FGFactoryGentleman.h"

#import "FGObjectBuilder.h"

@implementation FGFactoryGentleman

+ (id)buildForObjectClass:(Class)objectClass
{
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:baseDefinition] build];
}

+ (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait
{
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *traitDefinition = [self definitionForObjectClass:objectClass
                                                                    trait:trait];
    FGFactoryDefinition *finalDefinition = [baseDefinition mergedWithDefinition:traitDefinition];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:finalDefinition] build];
}

+ (id)buildForObjectClass:(Class)objectClass
       withFactoryDefiner:(FGFactoryDefinition *(^)())factoryDefiner
{
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *overriddenDefinition = factoryDefiner();
    FGFactoryDefinition *finalDefinition = [baseDefinition mergedWithDefinition:overriddenDefinition];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:finalDefinition] build];
}

+ (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait
       withFactoryDefiner:(FGFactoryDefinition *(^)())factoryDefiner
{
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *traitDefinition = [self definitionForObjectClass:objectClass
                                                                    trait:trait];
    FGFactoryDefinition *overriddenDefinition = factoryDefiner();
    FGFactoryDefinition *finalDefinition = [[baseDefinition mergedWithDefinition:traitDefinition]
            mergedWithDefinition:overriddenDefinition];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:finalDefinition] build];
}

+ (FGFactoryDefinition *)definitionForObjectClass:(Class)objectClass
{
    return [[FGFactoryDefinitionRegistry sharedInstance] factoryDefinitionForObjectClass:objectClass];
}

+ (FGFactoryDefinition *)definitionForObjectClass:(Class)objectClass
                                            trait:(NSString *)trait
{
    return [[FGFactoryDefinitionRegistry sharedInstance] factoryDefinitionForObjectClass:objectClass
                                                                                   trait:trait];
}

@end
