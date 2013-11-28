#import "User.h"

#import "Helpers.h"

@implementation User

- (BOOL)isValid
{
    return [self isValidName] &&
            [self.address isValid];
}

- (BOOL)isValidName
{
    return !isEmptyString(self.firstName) &&
            !isEmptyString(self.lastName);
}

- (NSString *)fullName
{
    if ([self isValidName]) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else {
        return @"";
    }
}

- (NSString *)envelopeAddress
{
    if ([self isValid]) {
        return [NSString stringWithFormat:@"%@\n%@ %@\n%@", [self fullName],
                                          self.address.houseNumber, self.address.street, self.address.city];
    } else {
        return @"";
    }
}

@end
