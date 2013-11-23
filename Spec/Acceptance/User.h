@interface User : NSObject
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;

- (BOOL)isValid;
- (NSString *)fullName;
@end
