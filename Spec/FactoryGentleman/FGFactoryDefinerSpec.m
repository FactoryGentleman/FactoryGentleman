#import "FGFactoryDefiner.h"

#import "FGFactoryDefinitionRegistry.h"

@interface FGFactoryDefiner (Spec)
- (instancetype)initWithObjectClass:(Class)objectClass
          factoryDefinitionRegistry:(FGFactoryDefinitionRegistry *)factoryDefinitionRegistry;
- (void)registerDefinitions;
@end

@interface MutableObjectFactoryDefiner : FGFactoryDefiner
+ (FGFactoryDefinition *)theDefinition;
@end

@implementation MutableObjectFactoryDefiner

+ (FGFactoryDefinition *)theDefinition
{
    static dispatch_once_t once;
    static FGFactoryDefinition *sharedDefinition;
    dispatch_once(&once, ^{
        FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                                fieldNames:[NSOrderedSet orderedSet]];
        sharedDefinition = [[FGFactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                     fieldDefinitions:@{}];
    });
    return sharedDefinition;
}

- (FGFactoryDefinition *)definition
{
    return [self.class theDefinition];
}

@end

SpecBegin(FGFactoryDefiner)
    __block FGFactoryDefiner *subject;
    __block Class definedClass;
    __block id factoryDefinitionRegistry;

    before(^{
        definedClass = NSString.class;
        factoryDefinitionRegistry = [OCMockObject mockForClass:FGFactoryDefinitionRegistry.class];
        subject = [[MutableObjectFactoryDefiner alloc] initWithObjectClass:definedClass
                                                 factoryDefinitionRegistry:factoryDefinitionRegistry];
    });

    context(@"when mutable factory is defined", ^{
        it(@"registers a factory definition with field definitions given", ^{
            [[factoryDefinitionRegistry expect] registerFactoryDefinition:MutableObjectFactoryDefiner.theDefinition
                                                                 forClass:definedClass];

            [subject registerDefinitions];

            [factoryDefinitionRegistry verify];
        });
    });
SpecEnd
