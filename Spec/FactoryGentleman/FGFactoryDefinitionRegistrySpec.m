#import "FGFactoryDefinitionRegistry.h"

SpecBegin(FGFactoryDefinitionRegistry)
    __block FGFactoryDefinitionRegistry *subject;
    __block Class requestedClass;

    before(^{
        subject = [[FGFactoryDefinitionRegistry alloc] init];
        requestedClass = NSString.class;
    });

    context(@"when no factory definition registered for requested class", ^{
        it(@"returns no factory definition", ^{
            expect([subject factoryDefinitionForObjectClass:requestedClass]).to.beNil();
        });
    });

    context(@"when factory definition registered for requested class", ^{
        __block FGFactoryDefinition *registeredDefinition;

        before(^{
            FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                                fieldNames:@[]];
            registeredDefinition = [[FGFactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                           fieldDefinitions:@[]];
        });

        before(^{
            [subject registerFactoryDefinition:registeredDefinition forClass:requestedClass];
        });

        it(@"returns no factory definition", ^{
            expect([subject factoryDefinitionForObjectClass:requestedClass]).to.equal(registeredDefinition);
        });
    });
SpecEnd
