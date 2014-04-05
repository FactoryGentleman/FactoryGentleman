#import "FGFactoryDefiner.h"

@interface FGFactoryGentleman : NSObject
+ (id)buildForObjectClass:(Class)objectClass;
+ (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait;
+ (id)buildForObjectClass:(Class)objectClass
       withFactoryDefiner:(FGFactoryDefinition *(^)())factoryDefiner;
+ (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait
       withFactoryDefiner:(FGFactoryDefinition *(^)())factoryDefiner;
@end

#define FGBuild(__OBJECT_CLASS__) \
[FGFactoryGentleman buildForObjectClass:[__OBJECT_CLASS__ class]]

#define FGBuildTrait(__OBJECT_CLASS__, __TRAIT__) \
[FGFactoryGentleman buildForObjectClass:[__OBJECT_CLASS__ class] trait:FGF(__TRAIT__)]

#define FGBuildWith(__OBJECT_CLASS__, __EXTRA_DEFINITION_BLOCK__) \
[FGFactoryGentleman buildForObjectClass:[__OBJECT_CLASS__ class] \
                     withFactoryDefiner:FG_DefineBlock(__EXTRA_DEFINITION_BLOCK__)]

#define FGBuildTraitWith(__OBJECT_CLASS__, __TRAIT__, __EXTRA_DEFINITION_BLOCK__) \
[FGFactoryGentleman buildForObjectClass:[__OBJECT_CLASS__ class] \
                                  trait:FGF(__TRAIT__ ) \
                     withFactoryDefiner:FG_DefineBlock(__EXTRA_DEFINITION_BLOCK__)]
