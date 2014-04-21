#import "FactoryGentleman.h"

#import "Friendship.h"

SpecBegin(Friendship)
    __block Friendship *subject;
    __block User *fromUser, *toUser;

    before(^{
        fromUser = FGBuild(User);
        toUser = FGBuild(User);
        subject = FGBuildWith(Friendship, ^(FGDefinitionBuilder *builder) {
            [builder field:@"fromUser" value:fromUser];
            [builder field:@"toUser" value:toUser];
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
