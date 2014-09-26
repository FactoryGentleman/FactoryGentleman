#import "FGFieldHelper.h"

@implementation FGFieldHelper

+ (SEL)setterForField:(NSString *)field
{
    NSString *setterString = [NSString stringWithFormat:@"set%@:", [self camelcaseForField:field]];
    return NSSelectorFromString(setterString);
}

+ (NSString *)camelcaseForField:(NSString *)field
{
    return [field stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                          withString:[[field substringToIndex:1] capitalizedString]];
}

@end
