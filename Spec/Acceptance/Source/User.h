#import "Address.h"

@interface User : NSObject
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) Address *address;

- (BOOL)isValid;
- (NSString *)fullName;
- (NSString *)envelopeAddress;
@end
