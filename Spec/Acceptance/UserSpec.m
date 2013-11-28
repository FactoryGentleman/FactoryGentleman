#import "User.h"

#import "FactoryGentleman.h"

SpecBegin(User)
    __block User *subject;

    context(@"has both first name & last name", ^{
        before(^{
            subject = FGBuild(User);
        });

        it(@"is valid", ^{
            expect([subject isValid]).to.beTruthy();
        });

        it(@"has a full name", ^{
            expect([subject fullName]).toNot.equal(@"");
        });
    });

    context(@"has no first name", ^{
        before(^{
            subject = FGBuildWith(User, field(firstName, nil));
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });

        it(@"has no full name", ^{
            expect([subject fullName]).to.equal(@"");
        });
    });

    context(@"has no last name", ^{
        before(^{
            subject = FGBuildWith(User, field(lastName, nil));
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });

        it(@"has no full name", ^{
            expect([subject fullName]).to.equal(@"");
        });
    });
SpecEnd
