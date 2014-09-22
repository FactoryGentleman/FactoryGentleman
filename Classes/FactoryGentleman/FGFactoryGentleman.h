#import "FGFactoryDefiner.h"

@interface FGFactoryGentleman : NSObject
- (id)buildForObjectClass:(Class)objectClass;
- (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait;
- (id)buildForObjectClass:(Class)objectClass
       withFactoryDefiner:(id)factoryDefiner;
- (id)buildForObjectClass:(Class)objectClass
                    trait:(NSString *)trait
       withFactoryDefiner:(id)factoryDefiner;
@end

extern BOOL FGAllowReadonly;

extern id FGBuild(Class objectClass);
extern id FGBuildTrait(Class objectClass, NSString *trait);
extern id FGBuildWith(Class objectClass, id factoryDefiner);
extern id FGBuildTraitWith(Class objectClass, NSString *trait, id factoryDefiner);
