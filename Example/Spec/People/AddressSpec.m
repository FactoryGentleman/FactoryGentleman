#import "Address.h"

SpecBegin(Address)
    __block Address *subject;

    context(@"has house number, street & city", ^{
        before(^{
            subject = FGBuild(Address.class);
        });

        it(@"is valid", ^{
            expect([subject isValid]).to.beTruthy();
        });
    });

    context(@"has no house number", ^{
        before(^{
            subject = FGBuildWith(Address.class, @{ @"houseNumber" : FGNil });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });
    });

    context(@"has no street", ^{
        before(^{
            subject = FGBuildWith(Address.class, @{ @"street" : FGNil });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });
    });

    context(@"has no city", ^{
        before(^{
            subject = FGBuildWith(Address.class, @{ @"city" : FGNil });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });
    });
SpecEnd
