@interface Value : NSObject
@property (nonatomic, readonly) NSValue *wrappedValue;

+ (Value *)value:(const void *)value
    withObjCType:(const char *)type;
@end
