#import "FactoryGentleman.h"

#import "Friendship.h"

FGFactoryBegin(Friendship)
    FGAssocField(fromUser, User);
    FGAssocFieldTrait(toUser, User, homeless);
    FGInitFrom(FriendshipFactory.class);
    FGInitWith(friendshipFromUser:toUser:, FGF(fromUser), FGF(toUser));
FGFactoryEnd
