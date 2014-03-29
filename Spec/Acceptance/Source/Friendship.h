#import "User.h"

@interface Friendship : NSObject
@property (nonatomic, readonly) User *fromUser;
@property (nonatomic, readonly) User *toUser;

- (instancetype)init __attribute__((unavailable("init not available ")));

- (NSArray *)users;
@end

@interface FriendshipFactory : NSObject
+ (Friendship *)friendshipFromUser:(User *)fromUser
                            toUser:(User *)toUser;
@end
