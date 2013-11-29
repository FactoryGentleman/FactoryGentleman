#import "FactoryDefiner.h"

#import "FactoryDefinitionRegistry.h"

@interface FactoryDefiner ()
@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, readonly) FactoryDefinitionRegistry *factoryDefinitionRegistry;
@end

@implementation FactoryDefiner

+ (void)initialize
{
    Class selfClass = (Class) self;
    if (selfClass != FactoryDefiner.class) {
        [[self new] registerDefinitions];
    }
}

- (instancetype)initWithObjectClass:(Class)objectClass
{
    return [self initWithObjectClass:objectClass
           factoryDefinitionRegistry:[FactoryDefinitionRegistry sharedInstance]];
}

- (instancetype)initWithObjectClass:(Class)objectClass
          factoryDefinitionRegistry:(FactoryDefinitionRegistry *)factoryDefinitionRegistry
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
    [self.factoryDefinitionRegistry
            registerFactoryDefinition:[self definition]
                             forClass:self.objectClass];
}

- (FactoryDefinition *)definition
{
    NSMutableDictionary *fieldDefinitions = [[NSMutableDictionary alloc] init];
    [self defineFieldDefinitions:fieldDefinitions];
    return [[FactoryDefinition alloc] initWithFieldDefinitions:fieldDefinitions];
}

- (void)defineFieldDefinitions:(NSMutableDictionary *)fieldDefinitions
{
}

@end