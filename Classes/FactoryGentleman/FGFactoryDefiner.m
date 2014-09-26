#import "FGFactoryDefiner.h"

@implementation FGFactoryDefiner

+ (void)initialize
{
    [[self new] registerDefinitions];
}

- (instancetype)initWithObjectClass:(Class)objectClass
{
    return [self initWithObjectClass:objectClass
           factoryDefinitionRegistry:[FGFactoryDefinitionRegistry sharedInstance]];
}

- (instancetype)initWithObjectClass:(Class)objectClass
          factoryDefinitionRegistry:(FGFactoryDefinitionRegistry *)factoryDefinitionRegistry
{
    self = [super init];
    if (self) {
        NSParameterAssert(objectClass);
        NSParameterAssert(factoryDefinitionRegistry);
        _objectClass = objectClass;
        _factoryDefinitionRegistry = factoryDefinitionRegistry;
    }
    return self;
}

- (void)registerDefinitions
{
}

- (void)registerBaseDefinition:(FGFactoryDefinition *)baseDefinition
                 traitDefiners:(NSDictionary *)traitDefiners
{
    [self registerBaseDefinition:baseDefinition];
    for (NSString *trait in traitDefiners) {
        void (^traitDefiner)(FGDefinitionBuilder *) = traitDefiners[trait];
        [self registerTraitDefiner:trait traitDefiner:traitDefiner];
    }
}

- (void)registerBaseDefinition:(FGFactoryDefinition *)baseDefinition
{
    [self.factoryDefinitionRegistry registerFactoryDefinition:baseDefinition
                                                     forClass:self.objectClass];
}

- (void)registerTraitDefiner:(NSString *)trait traitDefiner:(id)traitDefiner
{
    void (^traitDefinitionBlock)(FGDefinitionBuilder *) = traitDefiner;
    FGDefinitionBuilder *builder = [FGDefinitionBuilder builder];
    traitDefinitionBlock(builder);
    FGFactoryDefinition *traitDefinition = [builder build];
    [self.factoryDefinitionRegistry registerFactoryDefinition:traitDefinition
                                                     forClass:self.objectClass
                                                        trait:trait];
}

@end
