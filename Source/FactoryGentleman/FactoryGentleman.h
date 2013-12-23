#import "FactoryDefiner.h"
#import "FactoryDefinitionRegistry.h"

@interface FactoryGentleman : NSObject
+ (id)buildForObjectClass:(Class)objectClass;

+ (id)buildForObjectClass:(Class)objectClass
         withFieldDefiner:(void (^)(NSMutableDictionary *fieldDefinitions))fieldDefiner;
@end

#define FGBuild(__OBJECT_CLASS__) \
[FactoryGentleman buildForObjectClass:__OBJECT_CLASS__.class]

#define FGBuildWith(__OBJECT_CLASS__, __EXTRA_DEFINITIONS__) \
[FactoryGentleman buildForObjectClass:__OBJECT_CLASS__.class withFieldDefiner:^(NSMutableDictionary *fieldDefinitions) { \
__EXTRA_DEFINITIONS__ \
}]
