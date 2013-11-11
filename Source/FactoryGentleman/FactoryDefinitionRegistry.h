#import "FactoryDefinition.h"

@interface FactoryDefinitionRegistry : NSObject

// Singleton
+ (instancetype)sharedInstance;

- (FactoryDefinition *)factoryDefinitionForObjectClass:(Class)objectClass;

- (void)registerFactoryDefinition:(FactoryDefinition *)factoryDefinition
                         forClass:(Class)class;
@end
