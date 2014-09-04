#import "FGFactoryDefiner.h"

@interface FGFactoryGentleman : NSObject
- (id)buildForObjectClass:(Class)objectClass
                 readonly:(BOOL)readonly;
- (id)buildForObjectClass:(Class)objectClass
                 readonly:(BOOL)readonly
                    trait:(NSString *)trait;
- (id)buildForObjectClass:(Class)objectClass
                 readonly:(BOOL)readonly
       withFactoryDefiner:(id)factoryDefiner;
- (id)buildForObjectClass:(Class)objectClass
                 readonly:(BOOL)readonly
                    trait:(NSString *)trait
       withFactoryDefiner:(id)factoryDefiner;
@end

extern id FGBuild(Class objectClass);
extern id FGBuildTrait(Class objectClass, NSString *trait);
extern id FGBuildWith(Class objectClass, id factoryDefiner);
extern id FGBuildTraitWith(Class objectClass, NSString *trait, id factoryDefiner);
