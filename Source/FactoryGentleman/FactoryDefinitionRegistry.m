#import "FactoryDefinitionRegistry.h"

@interface FactoryDefinitionRegistry ()
@property NSMutableDictionary *factories;
@end

@implementation FactoryDefinitionRegistry

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
    static FactoryDefinitionRegistry *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Retrieval

- (FactoryDefinition *)factoryDefinitionForObjectClass:(Class)objectClass
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
