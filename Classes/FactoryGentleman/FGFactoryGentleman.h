#import "FGFactoryDefiner.h"

@interface FGFactoryGentleman : NSObject
+ (id)buildForObjectClass:(Class)objectClass
                 readonly:(BOOL)readonly;
+ (id)buildForObjectClass:(Class)objectClass
                 readonly:(BOOL)readonly
                    trait:(NSString *)trait;
+ (id)buildForObjectClass:(Class)objectClass
                 readonly:(BOOL)readonly
       withFactoryDefiner:(id)factoryDefiner;
+ (id)buildForObjectClass:(Class)objectClass
                 readonly:(BOOL)readonly
                    trait:(NSString *)trait
       withFactoryDefiner:(id)factoryDefiner;
@end

#ifdef FG_ALLOW_READONLY
    #define FGBuild(__OBJECT_CLASS__) \
        [FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__ \
                                       readonly:YES]
#else
    #define FGBuild(__OBJECT_CLASS__) \
        [FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__ \
                                       readonly:NO]
#endif

#ifdef FG_ALLOW_READONLY
    #define FGBuildTrait(__OBJECT_CLASS__, __TRAIT__) \
        [FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__ \
                                       readonly:YES \
                                          trait:__TRAIT__]
#else
    #define FGBuildTrait(__OBJECT_CLASS__, __TRAIT__) \
        [FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__ \
                                       readonly:NO \
                                          trait:__TRAIT__]
#endif

#ifdef FG_ALLOW_READONLY
    #define FGBuildWith(__OBJECT_CLASS__, __FACTORY_DEFINER__) \
        [FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__ \
                                       readonly:YES \
                             withFactoryDefiner:__FACTORY_DEFINER__]
#else
    #define FGBuildWith(__OBJECT_CLASS__, __FACTORY_DEFINER__) \
        [FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__ \
                                       readonly:NO \
                             withFactoryDefiner:__FACTORY_DEFINER__]
#endif

#ifdef FG_ALLOW_READONLY
    #define FGBuildTraitWith(__OBJECT_CLASS__, __TRAIT__, __FACTORY_DEFINER__) \
        [FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__ \
                                       readonly:YES \
                                          trait:__TRAIT__ \
                             withFactoryDefiner:__FACTORY_DEFINER__]
#else
    #define FGBuildTraitWith(__OBJECT_CLASS__, __TRAIT__, __FACTORY_DEFINER__) \
        [FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__ \
                                       readonly:NO \
                                          trait:__TRAIT__ \
                             withFactoryDefiner:__FACTORY_DEFINER__]
#endif
