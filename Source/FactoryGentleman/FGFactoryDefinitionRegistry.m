#import "FGFactoryDefinitionRegistry.h"

@interface FGFactoryDefinitionRegistry ()
@property NSMutableDictionary *factories;
@end

@implementation FGFactoryDefinitionRegistry

- (instancetype)init
{
    self = [super init];
    if (self) {
        _factories = [[NSMutableDictionary alloc] init];
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

- (FGFactoryDefinition *)factoryDefinitionForObjectClass:(Class)objectClass
                                                   trait:(NSString *)trait
{
    return [self.factories objectForKey:[self keyForObjectClass:objectClass
                                                          trait:trait]];
}

#pragma mark Registration

- (void)registerFactoryDefinition:(id)factoryDefinition
                         forClass:(Class)objectClass
{
    [self.factories setObject:factoryDefinition
                       forKey:[self keyForObjectClass:objectClass]];
}

- (void)registerFactoryDefinition:(FGFactoryDefinition *)factoryDefinition
                         forClass:(Class)objectClass
                            trait:(NSString *)trait
{
    [self.factories setObject:factoryDefinition
                       forKey:[self keyForObjectClass:objectClass
                                                trait:trait]];
}

- (NSString *)keyForObjectClass:(Class)objectClass
                          trait:(NSString *)trait
{
    return [[self keyForObjectClass:objectClass] stringByAppendingString:trait];
}

- (NSString *)keyForObjectClass:(Class)objectClass
{
    return NSStringFromClass(objectClass);
}

@end
