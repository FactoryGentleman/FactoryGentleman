#import "User.h"

SpecBegin(User)
    __block User *subject;

    it(@"has unique resourceID factory", ^{
        subject = FGBuild(User.class);
        User *anotherUser = FGBuild(User.class);
        expect(subject.resourceId).toNot.equal(anotherUser.resourceId);
    });

    context(@"has first name, last name & valid address", ^{
        before(^{
            subject = FGBuild(User.class);
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
            subject = FGBuildTrait(User.class, @"homeless");
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
            Address *address = FGBuildWith(Address.class, ^(FGDefinitionBuilder *builder) {
                [builder nilField:@"street"];
            });
            subject = FGBuildWith(User.class, @{ @"address" : address });
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
            subject = FGBuildWith(User.class, @{ @"firstName" : FGNil });
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
            subject = FGBuildWith(User.class, @{ @"lastName" : FGNil });
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
            subject = FGBuildWith(User.class, ^(FGDefinitionBuilder *builder) {
                [builder field:@"friendCount" unsignedIntegerValue:2];
            });
        });

        it(@"is NOT lonely", ^{
            expect([subject isLonely]).to.beFalsy();
        });
    });

    context(@"when has NO friends", ^{
        before(^{
            subject = FGBuildTraitWith(User.class, @"homeless", ^(FGDefinitionBuilder *builder) {
                [builder field:@"friendCount" unsignedIntegerValue:0];
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
