#import "FactoryDefinition.h"

#import "FieldDefinition.h"
#import "FactoryDefiner.h"

SpecBegin(FactoryDefinition)
    __block FactoryDefinition *subject;
    __block InitializerDefinition *originalInitializer;
    __block FieldDefinition *originalDefinition;
    __block FieldDefinition *originalBothDefinition;

    before(^{
        originalDefinition = [FieldDefinition withFieldName:@"original" definition:^id { return nil; }];
        originalBothDefinition = [FieldDefinition withFieldName:@"both" definition:^id { return nil; }];

        originalInitializer = [[InitializerDefinition alloc] initWithSelector:@selector(initWithObjectClass:)
                                                                fieldNames:@[@"original"]];

        subject = [[FactoryDefinition alloc] initWithInitializerDefinition:originalInitializer
                                                          fieldDefinitions:@[
                                                                  originalDefinition,
                                                                  originalBothDefinition
                                                          ]];
    });

    describe(@"-mergedWithDefinition:", ^{
        __block FactoryDefinition *givenFactoryDefinition;
        __block NSArray *fieldDefinitions;

        __block FieldDefinition *givenDefinition;
        __block FieldDefinition *givenBothDefinition;

        before(^{
            givenDefinition = [FieldDefinition withFieldName:@"given" definition:^id { return nil; }];
            givenBothDefinition = [FieldDefinition withFieldName:@"both" definition:^id { return nil; }];

            fieldDefinitions = @[ givenDefinition, givenBothDefinition ];
            givenFactoryDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:nil
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
                givenFactoryDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:nil
                                                                                 fieldDefinitions:fieldDefinitions];
            });

            it(@"new definition chooses original initializer", ^{
                expect([subject mergedWithDefinition:givenFactoryDefinition].initializerDefinition).to.equal(originalInitializer);
            });
        });

        context(@"when given definition has initializer", ^{
            __block InitializerDefinition *givenInitializer;

            before(^{
                givenInitializer = [[InitializerDefinition alloc] initWithSelector:@selector(init)
                                                                        fieldNames:@[]];
                givenFactoryDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:givenInitializer
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
