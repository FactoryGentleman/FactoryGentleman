#import "FGFactoryDefinitionRegistry.h"

SpecBegin(FGFactoryDefinitionRegistry)
    __block FGFactoryDefinitionRegistry *subject;
    __block Class requestedClass;
    __block NSString *trait;

    before(^{
        subject = [[FGFactoryDefinitionRegistry alloc] init];
        requestedClass = [NSString class];
        trait = @"trait";
    });

    it(@"returns the same instance", ^{
        expect([FGFactoryDefinitionRegistry sharedInstance]).to.beIdenticalTo([FGFactoryDefinitionRegistry sharedInstance]);
    });

    context(@"when no factory definition registered for requested class", ^{
        it(@"returns no factory definition", ^{
            expect([subject factoryDefinitionForObjectClass:requestedClass]).to.beNil();
        });

        it(@"returns no factory definition with trait", ^{
            expect([subject factoryDefinitionForObjectClass:requestedClass trait:trait]).to.beNil();
        });
    });

    context(@"when factory definition registered for requested class", ^{
        __block FGFactoryDefinition *registeredDefinition;

        before(^{
            FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                                    fieldNames:[NSOrderedSet orderedSet]];
            registeredDefinition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                              initializerDefinition:initializerDefinition
                                                                   fieldDefinitions:@{}];
        });

        before(^{
            [subject registerFactoryDefinition:registeredDefinition forClass:requestedClass];
        });

        it(@"returns no factory definition", ^{
            expect([subject factoryDefinitionForObjectClass:requestedClass]).to.equal(registeredDefinition);
        });
    });

    context(@"when factory definition registered for requested class trait", ^{
        __block FGFactoryDefinition *registeredDefinition;

        before(^{
            FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                                    fieldNames:[NSOrderedSet orderedSet]];
            registeredDefinition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                              initializerDefinition:initializerDefinition
                                                                   fieldDefinitions:@{}];
        });

        before(^{
            [subject registerFactoryDefinition:registeredDefinition forClass:requestedClass trait:trait];
        });

        it(@"returns no factory definition", ^{
            expect([subject factoryDefinitionForObjectClass:requestedClass trait:trait]).to.equal(registeredDefinition);
        });
    });
SpecEnd
