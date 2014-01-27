#import "Value.h"

@implementation Value

- (instancetype)initWithWrappedValue:(NSValue *)wrappedValue
{
    self = [super init];
    if (self) {
        NSParameterAssert(wrappedValue);
        _wrappedValue = wrappedValue;
    }
    return self;
}

+ (Value *)value:(const void *)value
    withObjCType:(const char *)type
{
    return [[Value alloc] initWithWrappedValue:[NSValue value:value
                                                 withObjCType:type]];
}

@end
