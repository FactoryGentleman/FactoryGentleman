@interface Address : NSObject
@property (nonatomic) NSString *houseNumber;
@property (nonatomic) NSString *street;
@property (nonatomic) NSString *city;

- (BOOL)isValid;
@end
