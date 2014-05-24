@interface FGValue : NSObject
@property (nonatomic, readonly) NSValue *wrappedValue;

+ (FGValue *)value:(const void *)value
      withObjCType:(const char *)type;
@end
