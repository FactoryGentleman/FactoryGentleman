#import "Address.h"

@interface User : NSObject
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic) Address *address;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName;

- (BOOL)isValid;
- (NSString *)fullName;
- (NSString *)envelopeAddress;
@end
