#import "FGFactoryDefinition.h"

SpecBegin(FGFactoryDefinition)
    __block FGFactoryDefinition *subject;
    __block id originalConstructor;
    __block FGInitializerDefinition *originalInitializer;
    __block FGFieldDefinition originalDefinition;
    __block FGFieldDefinition originalBothDefinition;

    before(^{
        originalDefinition = ^id { return nil; };
        originalBothDefinition = ^id { return nil; };

        originalConstructor = NSNumber.class;
        originalInitializer = [[FGInitializerDefinition alloc] initWithSelector:@selector(initWithObjectClass:)
                                                                     fieldNames:[NSOrderedSet orderedSetWithObject:@"original"]];

        NSDictionary *originalFieldDefinitions = @{
                @"original" : originalDefinition,
                @"both" : originalBothDefinition
        };
        subject = [[FGFactoryDefinition alloc] initWithConstructor:originalConstructor
                                             initializerDefinition:originalInitializer
                                                  fieldDefinitions:originalFieldDefinitions];
    });

    describe(@"-mergedWithDefinition:", ^{
        __block FGFactoryDefinition *givenFactoryDefinition;
        __block NSDictionary *givenFieldDefinitions;

        __block FGFieldDefinition givenDefinition;
        __block FGFieldDefinition givenBothDefinition;

        before(^{
            givenDefinition = ^id {
                return nil;
            };
            givenBothDefinition = ^id {
                return nil;
            };

            givenFieldDefinitions = @{
                    @"given" : givenDefinition,
                    @"both" : givenBothDefinition,
            };
            givenFactoryDefinition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                                initializerDefinition:nil
                                                                     fieldDefinitions:givenFieldDefinitions];
        });

        it(@"new definition contains original fields", ^{
            expect([subject mergedWithDefinition:givenFactoryDefinition].fieldDefinitions[@"original"]).to.equal(originalDefinition);
        });
        
        it(@"new definition contains given fields", ^{
            expect([subject mergedWithDefinition:givenFactoryDefinition].fieldDefinitions[@"given"]).to.equal(givenDefinition);
        });

        it(@"new definition chooses given fields over original", ^{
            expect([subject mergedWithDefinition:givenFactoryDefinition].fieldDefinitions[@"both"]).to.equal(givenBothDefinition);
        });

        context(@"when given definition has NO initializer", ^{
            before(^{
                givenFactoryDefinition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                                    initializerDefinition:nil
                                                                         fieldDefinitions:givenFieldDefinitions];
            });

            it(@"new definition chooses original initializer", ^{
                expect([subject mergedWithDefinition:givenFactoryDefinition].initializerDefinition).to.equal(originalInitializer);
            });
        });

        context(@"when given definition has initializer", ^{
            __block FGInitializerDefinition *givenInitializer;

            before(^{
                givenInitializer = [[FGInitializerDefinition alloc] initWithSelector:@selector(init)
                                                                          fieldNames:[NSOrderedSet orderedSet]];
                givenFactoryDefinition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                                    initializerDefinition:givenInitializer
                                                                         fieldDefinitions:givenFieldDefinitions];
            });

            it(@"new definition chooses original intiializer", ^{
                expect([subject mergedWithDefinition:givenFactoryDefinition].initializerDefinition).to.equal(givenInitializer);
            });
        });

        context(@"when given definition has NO initializer", ^{
            before(^{
                givenFactoryDefinition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                                    initializerDefinition:nil
                                                                         fieldDefinitions:givenFieldDefinitions];
            });

            it(@"new definition chooses original initializer", ^{
                expect([subject mergedWithDefinition:givenFactoryDefinition].constructor).to.equal(originalConstructor);
            });
        });

        context(@"when given definition has initializer", ^{
            __block id givenConstructor;

            before(^{
                givenConstructor = NSString.class;
                givenFactoryDefinition = [[FGFactoryDefinition alloc] initWithConstructor:givenConstructor
                                                                    initializerDefinition:nil
                                                                         fieldDefinitions:givenFieldDefinitions];
            });

            it(@"new definition chooses original intiializer", ^{
                expect([subject mergedWithDefinition:givenFactoryDefinition].constructor).to.equal(givenConstructor);
            });
        });
    });

    describe(@"-initializerFieldDefinitions", ^{
        it(@"returns the field definitions used by the initializer", ^{
            expect([subject initializerFieldDefinitions]).to.equal([NSOrderedSet orderedSetWithObject:originalDefinition]);
        });
    });

    describe(@"-setterFieldDefinitions", ^{
        it(@"returns the field definitions NOT used by the initializer", ^{
            expect([subject setterFieldDefinitions]).to.equal(@{ @"both" : originalBothDefinition });
        });
    });
SpecEnd
