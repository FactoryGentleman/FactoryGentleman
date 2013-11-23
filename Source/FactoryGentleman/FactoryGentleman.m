#import "FactoryGentleman.h"

#import "ObjectBuilder.h"

@implementation FactoryGentleman

+ (id)buildForObjectClass:(Class)objectClass
{
    return [[self objectBuilderForClass:objectClass] buildWithFieldDefinitions:[[NSDictionary alloc] init]];
}

+ (id)buildForObjectClass:(Class)objectClass
         withFieldDefiner:(void (^)(NSMutableDictionary *fieldDefinitions))fieldDefiner
{
    NSMutableDictionary *fieldDefinitions = [[NSMutableDictionary alloc] init];
    fieldDefiner(fieldDefinitions);
    return [[self objectBuilderForClass:objectClass] buildWithFieldDefinitions:fieldDefinitions];
}

+ (ObjectBuilder *)objectBuilderForClass:(Class)class
{
    return [[ObjectBuilder alloc] initWithObjectClass:class
                                           definition:[self definitionForObjectClass:class]];
}

+ (FactoryDefinition *)definitionForObjectClass:(Class)objectClass
{
    return [[FactoryDefinitionRegistry sharedInstance] factoryDefinitionForObjectClass:objectClass];
}

@end
