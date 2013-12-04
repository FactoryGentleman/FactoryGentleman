#import "Address.h"

@interface User : NSObject
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) Address *address;

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName;

- (BOOL)isValid;
- (NSString *)fullName;
- (NSString *)envelopeAddress;
@end
