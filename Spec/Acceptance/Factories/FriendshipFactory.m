#import "FGFactoryGentleman.h"

#import "Friendship.h"

FGFactoryBegin(Friendship)
    FGAssocField(fromUser, User);
    FGAssocField(toUser, User);
    FGInitFrom(FriendshipFactory.class);
    FGInitWith(friendshipFromUser:toUser:, FGF(fromUser), FGF(toUser));
FGFactoryEnd
