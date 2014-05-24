#import "Address.h"

#import "Helpers.h"

@implementation Address

- (BOOL)isValid
{
    return !isEmptyString(self.houseNumber) &&
            !isEmptyString(self.street) &&
            !isEmptyString(self.city);
}

@end
