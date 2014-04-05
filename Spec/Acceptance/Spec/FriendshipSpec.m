#import "FactoryGentleman.h"

#import "Friendship.h"

SpecBegin(Friendship)
    __block Friendship *subject;
    __block User *fromUser, *toUser;

    before(^{
        fromUser = FGBuild(User);
        toUser = FGBuild(User);
        subject = FGBuildWith(Friendship, ^{
            FGField(fromUser, fromUser);
            FGField(toUser, toUser);
        });
    });

    describe(@"-users", ^{
        it(@"returns array containing from user", ^{
            expect([subject users]).to.contain(fromUser);
        });

        it(@"returns array containing to user", ^{
            expect([subject users]).to.contain(toUser);
        });
    });
SpecEnd
