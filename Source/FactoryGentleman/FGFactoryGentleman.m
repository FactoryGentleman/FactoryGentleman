#import "FGFactoryGentleman.h"

#import "FGObjectBuilder.h"

@implementation FGFactoryGentleman

+ (id)buildForObjectClass:(Class)objectClass
{
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:[self definitionForObjectClass:objectClass]] build];
}

+ (id)buildForObjectClass:(Class)objectClass
       withFactoryDefiner:(FGFactoryDefinition *(^)())factoryDefiner
{
    FGFactoryDefinition *overriddenDefinition = factoryDefiner();
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *finalDefinition = [baseDefinition mergedWithDefinition:overriddenDefinition];
    FGObjectBuilder *builder = [[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                                                 definition:finalDefinition];
    return [builder build];
}

+ (FGFactoryDefinition *)definitionForObjectClass:(Class)objectClass
{
    return [[FGFactoryDefinitionRegistry sharedInstance] factoryDefinitionForObjectClass:objectClass];
}

@end
