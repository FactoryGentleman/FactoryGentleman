#import "FactoryGentleman.h"

#import "ObjectBuilder.h"

@implementation FactoryGentleman

+ (id)buildForObjectClass:(Class)objectClass
{
    return [[[ObjectBuilder alloc] initWithObjectClass:objectClass
                                            definition:[self definitionForObjectClass:objectClass]] build];
}

+ (id)buildForObjectClass:(Class)objectClass
         withFieldDefiner:(void (^)(NSMutableDictionary *fieldDefinitions))fieldDefiner
{
    NSMutableDictionary *fieldDefinitions = [[NSMutableDictionary alloc] init];
    fieldDefiner(fieldDefinitions);
    FactoryDefinition *overriddenDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:nil
                                                                                      fieldDefinitions:fieldDefinitions];
    FactoryDefinition *definition = [[self definitionForObjectClass:objectClass] mergedWithDefinition:overriddenDefinition];
    return [[[ObjectBuilder alloc] initWithObjectClass:objectClass
                                            definition:definition] build];
}

+ (FactoryDefinition *)definitionForObjectClass:(Class)objectClass
{
    return [[FactoryDefinitionRegistry sharedInstance] factoryDefinitionForObjectClass:objectClass];
}

@end
