#import "FGValue.h"

@implementation FGValue

- (instancetype)initWithWrappedValue:(NSValue *)wrappedValue
{
    self = [super init];
    if (self) {
        NSParameterAssert(wrappedValue);
        _wrappedValue = wrappedValue;
    }
    return self;
}

+ (FGValue *)value:(const void *)value
      withObjCType:(const char *)type
{
    return [[FGValue alloc] initWithWrappedValue:[NSValue value:value
                                                   withObjCType:type]];
}

@end
