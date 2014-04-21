#import "FactoryGentleman.h"

#import "Friendship.h"

FGFactoryBegin(Friendship)
    [builder field:@"fromUser" assoc:User.class];
    [builder field:@"toUser" assoc:User.class trait:@"homeless"];
    [builder initFrom:FriendshipFactory.class];
    [builder initWith:@selector(friendshipFromUser:toUser:) fieldNames:@[ @"fromUser", @"toUser" ]];
FGFactoryEnd
