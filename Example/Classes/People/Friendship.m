#import "Friendship.h"

@implementation Friendship

- (instancetype)initWithFromUser:(User *)fromUser
                          toUser:(User *)toUser
{
    self = [super init];
    if (self) {
        NSParameterAssert(fromUser);
        NSParameterAssert(toUser);
        _fromUser = fromUser;
        _toUser = toUser;
    }
    return self;
}

- (NSArray *)users
{
    return @[
            self.toUser,
            self.fromUser
    ];
}

@end

@implementation FriendshipFactory

+ (Friendship *)friendshipFromUser:(User *)fromUser
                            toUser:(User *)toUser
{
    return [[Friendship alloc] initWithFromUser:fromUser
                                         toUser:toUser];
}

@end
