#import "FGNilValue.h"

@implementation FGNilValue

+ (instancetype)nilValue
{
    return [[[self class] alloc] init];
}

@end
