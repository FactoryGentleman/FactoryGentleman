#import "Address.h"

@interface User : NSObject
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic) NSNumber *resourceId;
@property (nonatomic) Address *address;
@property (nonatomic) NSUInteger friendCount;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName;

- (BOOL)isLonely;
- (BOOL)isValid;
- (NSString *)fullName;
- (NSString *)envelopeAddress;
@end
