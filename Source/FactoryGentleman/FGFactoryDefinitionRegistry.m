#import "FGFactoryDefinitionRegistry.h"

@interface FGFactoryDefinitionRegistry ()
@property NSMutableDictionary *factories;
@end

@implementation FGFactoryDefinitionRegistry

- (instancetype)init
{
    self = [super init];
    if (self) {
        _factories = @{}.mutableCopy;
    }
    return self;
}

#pragma mark Singleton

+ (instancetype)sharedInstance
{
    static FGFactoryDefinitionRegistry *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Retrieval

- (FGFactoryDefinition *)factoryDefinitionForObjectClass:(Class)objectClass
{
    return [self.factories objectForKey:[self keyForObjectClass:objectClass]];
}

#pragma mark Registration

- (void)registerFactoryDefinition:(id)factoryDefinition
                         forClass:(Class)class
{
    [self.factories setObject:factoryDefinition
                       forKey:[self keyForObjectClass:class]];
}

- (NSString *)keyForObjectClass:(Class)objectClass
{
    return NSStringFromClass(objectClass);
}

@end
