#import "FGFactoryDefiner.h"
#import "FGFactoryDefinitionRegistry.h"

@interface FGFactoryGentleman : NSObject
+ (id)buildForObjectClass:(Class)objectClass;

+ (id)buildForObjectClass:(Class)objectClass
         withFieldDefiner:(void (^)(NSMutableArray *fieldDefinitions))fieldDefiner;
@end

#define FGBuild(__OBJECT_CLASS__) \
[FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__.class]

#define FGBuildWith(__OBJECT_CLASS__, __EXTRA_DEFINITIONS__) \
[FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__.class withFieldDefiner:^(NSMutableArray *fieldDefinitions) { \
__EXTRA_DEFINITIONS__ \
}]
