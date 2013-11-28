@interface FactoryDefiner : NSObject

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithObjectClass:(Class)objectClass;

- (void)defineFieldDefinitions:(NSMutableDictionary *)fieldDefinitions;

@end

#define FactoryBegin(__CLASS__) \
@interface __CLASS__##FactoryDefiner : FactoryDefiner \
@property (nonatomic, retain) Class class; \
@end \
@implementation __CLASS__##FactoryDefiner \
- (instancetype)init \
{ \
    self = [super initWithObjectClass:__CLASS__.class]; \
    return self; \
} \
- (void)defineFieldDefinitions:(NSMutableDictionary *)fieldDefinitions \
{ \

#define field(__FIELD_NAME__, __FIELD_VALUE__) \
    [fieldDefinitions setObject:^{return (__FIELD_VALUE__);} forKey:@#__FIELD_NAME__]; \

#define FactoryEnd \
} \
@end
