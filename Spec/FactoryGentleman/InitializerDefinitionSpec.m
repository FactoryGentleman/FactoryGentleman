#import "InitializerDefinition.h"

#import "User.h"

SpecBegin(InitializerDefinition)
    __block InitializerDefinition *subject;
    __block SEL selector;

    describe(@"+definitionWithSelector:,...", ^{
        context(@"when given an initializer with no field names", ^{
            before(^{
                selector = @selector(init);
                subject = [InitializerDefinition definitionWithSelector:selector];
            });

            it(@"creates a definition with the given selector", ^{
                expect(subject.selector).to.equal(selector);
            });

            it(@"creates a definition with no field names", ^{
                expect(subject.fieldNames).to.beEmpty();
            });
        });

        context(@"when given an initializer with multiple field names", ^{
            __block NSString *firstFieldName, *secondFieldName;

            before(^{
                selector = @selector(initWithFirstName:lastName:);
                firstFieldName = @"first";
                secondFieldName = @"second";
                subject = [InitializerDefinition definitionWithSelector:selector, firstFieldName, secondFieldName];
            });

            it(@"creates a definition with the given selector", ^{
                expect(subject.selector).to.equal(selector);
            });

            it(@"creates a definition with an array of the given field names", ^{
                NSArray *expectedFieldNames = @[ firstFieldName, secondFieldName ];
                expect(subject.fieldNames).to.equal(expectedFieldNames);
            });
        });
    });
SpecEnd
