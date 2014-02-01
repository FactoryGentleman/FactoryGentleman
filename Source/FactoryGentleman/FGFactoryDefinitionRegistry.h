#import "FGFactoryDefinition.h"

@interface FGFactoryDefinitionRegistry : NSObject
// Singleton
+ (instancetype)sharedInstance;

- (FGFactoryDefinition *)factoryDefinitionForObjectClass:(Class)objectClass;

- (void)registerFactoryDefinition:(FGFactoryDefinition *)factoryDefinition
                         forClass:(Class)class;
@end
