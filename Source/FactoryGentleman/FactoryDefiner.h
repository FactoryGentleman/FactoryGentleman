@interface FactoryDefiner : NSObject

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithObjectClass:(Class)objectClass;

- (void)defineFields:(NSMutableDictionary *)fields;

@end

#define FactoryBegin(__CLASS__) \
@interface __CLASS__##FactoryDefinition : FactoryDefiner \
@property (nonatomic, retain) Class class; \
@end \
@implementation __CLASS__##FactoryDefinition \
- (instancetype)init \
{ \
    self = [super initWithObjectClass:__CLASS__.class]; \
    return self; \
} \
- (void)defineFields:(NSMutableDictionary *)fields \
{ \

#define field(__FIELD_NAME__, __FIELD_VALUE__) \
    [fields setObject:^{return (__FIELD_VALUE__);} forKey:__FIELD_NAME__]; \

#define FactoryEnd \
} \
@end
