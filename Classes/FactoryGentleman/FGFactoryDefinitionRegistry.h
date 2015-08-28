#import <Foundation/Foundation.h>

#import "FGFactoryDefinition.h"

@interface FGFactoryDefinitionRegistry : NSObject
// Singleton
+ (instancetype)sharedInstance;

- (FGFactoryDefinition *)factoryDefinitionForObjectClass:(Class)objectClass;
- (FGFactoryDefinition *)factoryDefinitionForObjectClass:(Class)objectClass
                                                   trait:(NSString *)trait;

- (void)registerFactoryDefinition:(FGFactoryDefinition *)factoryDefinition
                         forClass:(Class)objectClass;
- (void)registerFactoryDefinition:(FGFactoryDefinition *)factoryDefinition
                         forClass:(Class)objectClass
                            trait:(NSString *)trait;
@end
