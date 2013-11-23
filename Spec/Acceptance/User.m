#import "User.h"

@implementation User

- (BOOL)isValid
{
    return ![self isEmptyString:self.firstName] &&
            ![self isEmptyString:self.lastName];
}

- (BOOL)isEmptyString:(NSString *)string
{
    return string == nil || [string isEqual:@""];
}

- (NSString *)fullName
{
    if ([self isValid]) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else {
        return @"";
    }
}

@end
