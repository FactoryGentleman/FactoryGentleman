#import "FactoryGentleman.h"

#import "FGObjectBuilder.h"
#import "FGFactoryDefinitionRegistry.h"

@implementation FGFactoryGentleman

#ifdef DEBUG
+ (void)load {
    [super load];
    [[NSUserDefaults standardUserDefaults] setValue:@"GcovTestObserver"
                                             forKey:@"XCTestObserverClass"];
}
#endif

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
       withFactoryDefiner:(id)factoryDefiner
{
    NSParameterAssert(objectClass);
    NSParameterAssert(factoryDefiner);
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *overriddenDefinition;
    if ([factoryDefiner isKindOfClass:NSDictionary.class]) {
        overriddenDefinition = [self overriddenDefinitionFromDefinitionDictionary:factoryDefiner];
    } else {
        overriddenDefinition = [self overriddenDefinitionFromDefiner:factoryDefiner];
    }
    FGFactoryDefinition *finalDefinition = [baseDefinition mergedWithDefinition:overriddenDefinition];
    return [[[FGObjectBuilder alloc] initWithObjectClass:objectClass
                                              definition:finalDefinition] build];
}

+ (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait
       withFactoryDefiner:(id)factoryDefiner
{
    NSParameterAssert(objectClass);
    NSParameterAssert(trait);
    NSParameterAssert(factoryDefiner);
    FGFactoryDefinition *baseDefinition = [self definitionForObjectClass:objectClass];
    FGFactoryDefinition *traitDefinition = [self definitionForObjectClass:objectClass
                                                                    trait:trait];
    FGFactoryDefinition *overriddenDefinition;
    if ([factoryDefiner isKindOfClass:NSDictionary.class]) {
        overriddenDefinition = [self overriddenDefinitionFromDefinitionDictionary:factoryDefiner];
    } else {
        overriddenDefinition = [self overriddenDefinitionFromDefiner:factoryDefiner];
    }
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
    return [builder build];
}

+ (FGFactoryDefinition *)overriddenDefinitionFromDefinitionDictionary:(NSDictionary *)definitionDictionary
{
    FGDefinitionBuilder *builder = [FGDefinitionBuilder builder];
    for (NSString *fieldName in definitionDictionary) {
        [builder field:fieldName value:definitionDictionary[fieldName]];
    }
    return [builder build];
}

@end
