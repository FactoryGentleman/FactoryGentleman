#import "ObjectBuilder.h"

#import "ExampleMutableObject.h"

SpecBegin(ObjectBuilder)
    __block ObjectBuilder *subject;

    __block id (^buildObject)();

    before(^{
        NSDictionary *definedFields = @{
                @"mutableStringProperty" : ^{ return @"some random string"; },
                @"mutableIntProperty" : ^{ return 3; },
                @"mutableArrayProperty" : ^{ return @[ @"random string in array" ]; },
                @"nonExistentProperty" : ^{ return @"this will never work"; }
        };
        FactoryDefinition *definition = [[FactoryDefinition alloc] initWithFieldDefinitions:definedFields];
        subject = [[ObjectBuilder alloc] initWithObjectClass:ExampleMutableObject.class
                                                  definition:definition];
    });

    sharedExamplesFor(@"mutable object builder", ^(NSDictionary *data) {
        it(@"returns a new instance of the class", ^{
            expect(buildObject()).to.beKindOf(ExampleMutableObject.class);
        });

        it(@"new instance has object values defined", ^{
            expect([buildObject() mutableArrayProperty]).to.equal(@[ @"random string in array" ]);
        });

        it(@"new instance has primitive values defined", ^{
            expect([buildObject() mutableIntProperty]).to.equal(3);
        });
    });

    describe(@"-build", ^{
        before(^{
            buildObject = ^id {
                return [subject build];
            };
        });

        itBehavesLike(@"mutable object builder", nil);
    });

    describe(@"-buildWithFields:", ^{
        before(^{
            NSDictionary *overwrittenFields = @{
                @"mutableStringProperty" : @"totally new value"
            };
            buildObject = ^id {
                return [subject buildWithFields:overwrittenFields];
            };
        });

        itBehavesLike(@"mutable object builder", nil);

        it(@"overrides defined fields with the fields given", ^{
            expect([buildObject() mutableStringProperty]).to.equal(@"totally new value");
        });
    });
SpecEnd
