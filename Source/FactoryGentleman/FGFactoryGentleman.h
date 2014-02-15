#import "FGFactoryDefiner.h"
#import "FGFactoryDefinitionRegistry.h"

@interface FGFactoryGentleman : NSObject
+ (id)buildForObjectClass:(Class)objectClass;
+ (id)buildForObjectClass:(Class)objectClass
       withFactoryDefiner:(FGFactoryDefinition *(^)())factoryDefiner;
@end

#define FGBuild(__OBJECT_CLASS__) \
[FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__.class]

#define FGBuildWith(__OBJECT_CLASS__, __EXTRA_DEFINITION_BLOCK__) \
[FGFactoryGentleman buildForObjectClass:__OBJECT_CLASS__.class withFactoryDefiner:^FGFactoryDefinition *{ \
    __block FGInitializerDefinition *initializerDefinition = nil; \
    __block NSMutableDictionary *fieldDefinitions = [[NSMutableDictionary alloc] init]; \
    void (^defineBlock)() = __EXTRA_DEFINITION_BLOCK__; \
    defineBlock(); \
    return [[FGFactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition \
                                                     fieldDefinitions:fieldDefinitions]; \
}]
