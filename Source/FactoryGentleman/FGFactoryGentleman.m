#import "FGFactoryGentleman.h"

#import "FGObjectBuilder.h"

@implementation FGFactoryGentleman

+ (id)buildForObjectClass:(Class)objectClass
{
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:[self definitionForObjectClass:objectClass]] build];
}

+ (id)buildForObjectClass:(Class)objectClass
         withFieldDefiner:(void (^)(NSMutableArray *fieldDefinitions))fieldDefiner
{
    NSMutableArray *fieldDefinitions = [[NSMutableArray alloc] init];
    fieldDefiner(fieldDefinitions);
    FGFactoryDefinition *overriddenDefinition = [[FGFactoryDefinition alloc] initWithInitializerDefinition:nil
                                                                                          fieldDefinitions:fieldDefinitions];
    FGFactoryDefinition *definition = [[self definitionForObjectClass:objectClass] mergedWithDefinition:overriddenDefinition];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:definition] build];
}

+ (FGFactoryDefinition *)definitionForObjectClass:(Class)objectClass
{
    return [[FGFactoryDefinitionRegistry sharedInstance] factoryDefinitionForObjectClass:objectClass];
}

@end
