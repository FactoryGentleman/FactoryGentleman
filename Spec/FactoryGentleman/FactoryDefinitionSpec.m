#import "FactoryDefinition.h"

SpecBegin(FactoryDefinition)
    __block FactoryDefinition *subject;
    __block InitializerDefinition *originalInitializer;
    __block id (^original)();
    __block id (^originalBoth)();

    before(^{
        original = ^id {
            return nil;
        };
        originalBoth = ^id {
            return nil;
        };
        originalInitializer = [[InitializerDefinition alloc] initWithSelector:@selector(initWithObjectClass:)
                                                                fieldNames:@[@"original"]];
        subject = [[FactoryDefinition alloc] initWithInitializerDefinition:originalInitializer
                                                          fieldDefinitions:@{
                                                                  @"original" : original,
                                                                  @"both" : originalBoth
                                                          }];
    });

    describe(@"-mergedWithDefinition:", ^{
        __block FactoryDefinition *givenDefinition;
        __block NSDictionary *fieldDefinitions;
        __block id (^given)();
        __block id (^givenBoth)();

        before(^{
            given = ^id {
                return nil;
            };
            givenBoth = ^id {
                return nil;
            };
            fieldDefinitions = @{
                    @"given" : given,
                    @"both" : givenBoth
            };
            givenDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:nil
                                                                      fieldDefinitions:fieldDefinitions];
        });

        it(@"new definition contains original fields", ^{
            expect([subject mergedWithDefinition:givenDefinition].fieldDefinitions[@"original"]).to.equal(original);
        });
        
        it(@"new definition contains given fields", ^{
            expect([subject mergedWithDefinition:givenDefinition].fieldDefinitions[@"given"]).to.equal(given);
        });

        it(@"new definition chooses given fields over original", ^{
            expect([subject mergedWithDefinition:givenDefinition].fieldDefinitions[@"both"]).to.equal(givenBoth);
        });

        context(@"when given definition has NO initializer", ^{
            before(^{
                givenDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:nil
                                                                          fieldDefinitions:fieldDefinitions];
            });

            it(@"new definition chooses original initializer", ^{
                expect([subject mergedWithDefinition:givenDefinition].initializerDefinition).to.equal(originalInitializer);
            });
        });

        context(@"when given definition has initializer", ^{
            __block InitializerDefinition *givenInitializer;

            before(^{
                givenInitializer = [[InitializerDefinition alloc] initWithSelector:@selector(init)
                                                                        fieldNames:@[]];
                givenDefinition = [[FactoryDefinition alloc] initWithInitializerDefinition:givenInitializer
                                                                          fieldDefinitions:fieldDefinitions];
            });

            it(@"new definition chooses original intiializer", ^{
                expect([subject mergedWithDefinition:givenDefinition].initializerDefinition).to.equal(givenInitializer);
            });
        });
    });

    describe(@"-initializerFieldDefinitions", ^{
        it(@"returns the field definitions used by the initializer", ^{
            expect([subject initializerFieldDefinitions]).to.equal(@{ @"original" : original });
        });
    });

    describe(@"-setterFieldDefinitions", ^{
        it(@"returns the field definitions NOT used by the initializer", ^{
            expect([subject setterFieldDefinitions]).to.equal(@{ @"both" : originalBoth });
        });
    });
SpecEnd
