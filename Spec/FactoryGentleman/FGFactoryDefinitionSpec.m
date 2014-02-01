#import "FGFactoryDefinition.h"

#import "FGFieldDefinition.h"
#import "FGFactoryDefiner.h"

SpecBegin(FGFactoryDefinition)
    __block FGFactoryDefinition *subject;
    __block FGInitializerDefinition *originalInitializer;
    __block FGFieldDefinition *originalDefinition;
    __block FGFieldDefinition *originalBothDefinition;

    before(^{
        originalDefinition = [FGFieldDefinition withFieldName:@"original" definition:^id {
            return nil;
        }];
        originalBothDefinition = [FGFieldDefinition withFieldName:@"both" definition:^id {
            return nil;
        }];

        originalInitializer = [[FGInitializerDefinition alloc] initWithSelector:@selector(initWithObjectClass:)
                                                                fieldNames:@[@"original"]];

        subject = [[FGFactoryDefinition alloc] initWithInitializerDefinition:originalInitializer
                                                          fieldDefinitions:@[
                                                                  originalDefinition,
                                                                  originalBothDefinition
                                                          ]];
    });

    describe(@"-mergedWithDefinition:", ^{
        __block FGFactoryDefinition *givenFactoryDefinition;
        __block NSArray *fieldDefinitions;

        __block FGFieldDefinition *givenDefinition;
        __block FGFieldDefinition *givenBothDefinition;

        before(^{
            givenDefinition = [FGFieldDefinition withFieldName:@"given" definition:^id {
                return nil;
            }];
            givenBothDefinition = [FGFieldDefinition withFieldName:@"both" definition:^id {
                return nil;
            }];

            fieldDefinitions = @[ givenDefinition, givenBothDefinition ];
            givenFactoryDefinition = [[FGFactoryDefinition alloc] initWithInitializerDefinition:nil
                                                                             fieldDefinitions:fieldDefinitions];
        });

        it(@"new definition contains original fields", ^{
            expect([subject mergedWithDefinition:givenFactoryDefinition].fieldDefinitions).to.contain(originalDefinition);
        });
        
        it(@"new definition contains given fields", ^{
            expect([subject mergedWithDefinition:givenFactoryDefinition].fieldDefinitions).to.contain(givenDefinition);
        });

        it(@"new definition chooses given fields over original", ^{
            expect([subject mergedWithDefinition:givenFactoryDefinition].fieldDefinitions).to.contain(givenBothDefinition);
        });

        context(@"when given definition has NO initializer", ^{
            before(^{
                givenFactoryDefinition = [[FGFactoryDefinition alloc] initWithInitializerDefinition:nil
                                                                                 fieldDefinitions:fieldDefinitions];
            });

            it(@"new definition chooses original initializer", ^{
                expect([subject mergedWithDefinition:givenFactoryDefinition].initializerDefinition).to.equal(originalInitializer);
            });
        });

        context(@"when given definition has initializer", ^{
            __block FGInitializerDefinition *givenInitializer;

            before(^{
                givenInitializer = [[FGInitializerDefinition alloc] initWithSelector:@selector(init)
                                                                        fieldNames:@[]];
                givenFactoryDefinition = [[FGFactoryDefinition alloc] initWithInitializerDefinition:givenInitializer
                                                                                 fieldDefinitions:fieldDefinitions];
            });

            it(@"new definition chooses original intiializer", ^{
                expect([subject mergedWithDefinition:givenFactoryDefinition].initializerDefinition).to.equal(givenInitializer);
            });
        });
    });

    describe(@"-initializerFieldDefinitions", ^{
        it(@"returns the field definitions used by the initializer", ^{
            expect([subject initializerFieldDefinitions]).to.equal(@[ originalDefinition ]);
        });
    });

    describe(@"-setterFieldDefinitions", ^{
        it(@"returns the field definitions NOT used by the initializer", ^{
            expect([subject setterFieldDefinitions]).to.equal(@[ originalBothDefinition ]);
        });
    });
SpecEnd
