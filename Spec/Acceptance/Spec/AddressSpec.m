#import "FactoryGentleman.h"

#import "Address.h"

SpecBegin(Address)
    __block Address *subject;

    context(@"has house number, street & city", ^{
        before(^{
            subject = FGBuild(Address);
        });

        it(@"is valid", ^{
            expect([subject isValid]).to.beTruthy();
        });
    });

    context(@"has no house number", ^{
        before(^{
            subject = FGBuildWith(Address, @{ @"houseNumber" : FGNil });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });
    });

    context(@"has no street", ^{
        before(^{
            subject = FGBuildWith(Address, @{ @"street" : FGNil });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });
    });

    context(@"has no city", ^{
        before(^{
            subject = FGBuildWith(Address, @{ @"city" : FGNil });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });
    });
SpecEnd
