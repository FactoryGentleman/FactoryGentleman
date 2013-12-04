#import "FactoryDefiner.h"

#import "FactoryDefinitionRegistry.h"

@interface FactoryDefiner (Spec)
- (instancetype)initWithObjectClass:(Class)objectClass
          factoryDefinitionRegistry:(FactoryDefinitionRegistry *)factoryDefinitionRegistry;
- (void)registerDefinitions;
@end

@interface MutableObjectFactoryDefiner : FactoryDefiner
+ (FactoryDefinition *)theDefinition;
@end

@implementation MutableObjectFactoryDefiner

+ (FactoryDefinition *)theDefinition
{
    static dispatch_once_t once;
    static FactoryDefinition *sharedDefinition;
    dispatch_once(&once, ^{
        InitializerDefinition *initializerDefinition = [[InitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                            fieldNames:@[]];
        sharedDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                   fieldDefinitions:@{}];
    });
    return sharedDefinition;
}

- (FactoryDefinition *)definition
{
    return [self.class theDefinition];
}

@end

SpecBegin(FactoryDefiner)
    __block FactoryDefiner *subject;
    __block Class definedClass;
    __block id factoryDefinitionRegistry;

    before(^{
        definedClass = NSString.class;
        factoryDefinitionRegistry = [OCMockObject mockForClass:FactoryDefinitionRegistry.class];
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
