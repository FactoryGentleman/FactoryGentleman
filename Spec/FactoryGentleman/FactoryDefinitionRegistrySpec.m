#import "FactoryDefinitionRegistry.h"

SpecBegin(FactoryDefinitionRegistry)
    __block FactoryDefinitionRegistry *subject;
    __block Class requestedClass;

    before(^{
        subject = [[FactoryDefinitionRegistry alloc] init];
        requestedClass = NSString.class;
    });

    context(@"when no factory definition registered for requested class", ^{
        it(@"returns no factory definition", ^{
            expect([subject factoryDefinitionForObjectClass:requestedClass]).to.beNil();
        });
    });

    context(@"when factory definition registered for requested class", ^{
        __block FactoryDefinition *registeredDefinition;

        before(^{
            InitializerDefinition *initializerDefinition = [[InitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                                fieldNames:@[]];
            registeredDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
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
