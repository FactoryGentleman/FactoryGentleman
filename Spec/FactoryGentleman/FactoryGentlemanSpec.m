#import "FactoryGentleman.h"

SpecBegin(FactoryGentleman)
    __block FactoryGentleman *subject;

    before(^{
        subject = [[FactoryGentleman alloc] init];
    });

    context(@"when initialized", ^{
        it(@"is not nil", ^{
            expect(subject).toNot.beNil();
        });
    });

SpecEnd
