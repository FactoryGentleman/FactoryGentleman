#import "User.h"

#import "FactoryGentleman.h"

SpecBegin(User)
    __block User *subject;

    it(@"has unique resourceID factory", ^{
        subject = FGBuild(User);
        User *anotherUser = FGBuild(User);
        expect(subject.resourceId).toNot.equal(anotherUser.resourceId);
    });

    context(@"has first name, last name & valid address", ^{
        before(^{
            subject = FGBuild(User);
        });

        it(@"is valid", ^{
            expect([subject isValid]).to.beTruthy();
        });

        it(@"has no full name", ^{
            expect([subject fullName]).toNot.equal(@"");
        });

        it(@"has no envelope address", ^{
            expect([subject envelopeAddress]).toNot.equal(@"");
        });
    });

    context(@"when homeless", ^{
        before(^{
            subject = FGBuildTrait(User, homeless);
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });

        it(@"has no full name", ^{
            expect([subject fullName]).toNot.equal(@"");
        });

        it(@"has no envelope address", ^{
            expect([subject envelopeAddress]).to.equal(@"");
        });
    });

    context(@"has first name, last name & invalid address", ^{
        before(^{
            Address *address = FGBuildWith(Address, ^{
                FGField(street, nil);
            });
            subject = FGBuildWith(User, ^{
                FGField(address, address);
            });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });

        it(@"has a full name", ^{
            expect([subject fullName]).toNot.equal(@"");
        });

        it(@"has no envelope address", ^{
            expect([subject envelopeAddress]).to.equal(@"");
        });
    });

    context(@"has no first name", ^{
        before(^{
            subject = FGBuildWith(User, ^{
                FGField(firstName, nil);
            });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });

        it(@"has no full name", ^{
            expect([subject fullName]).to.equal(@"");
        });

        it(@"has no envelope address", ^{
            expect([subject envelopeAddress]).to.equal(@"");
        });
    });

    context(@"has no last name", ^{
        before(^{
            subject = FGBuildWith(User, ^{
                FGField(lastName, nil);
            });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });

        it(@"has no full name", ^{
            expect([subject fullName]).to.equal(@"");
        });

        it(@"has no envelope address", ^{
            expect([subject envelopeAddress]).to.equal(@"");
        });
    });

    context(@"when has friends", ^{
        before(^{
            NSUInteger friendCount = 2;
            subject = FGBuildWith(User, ^{
                FGField(friendCount, FGValue(friendCount));
            });
        });

        it(@"is NOT lonely", ^{
            expect([subject isLonely]).to.beFalsy();
        });
    });

    context(@"when has NO friends", ^{
        before(^{
            NSUInteger friendCount = 0;
            subject = FGBuildTraitWith(User, homeless, ^{
                FGField(friendCount, FGValue(friendCount));
            });
        });

        it(@"is lonely", ^{
            expect([subject isLonely]).to.beTruthy();
        });

        it(@"has no envelope address", ^{
            expect([subject envelopeAddress]).to.equal(@"");
        });
    });
SpecEnd
