#import "FactoryDefinition.h"

@interface FactoryDefiner : NSObject
- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithObjectClass:(Class)objectClass;

- (FactoryDefinition *)definition;
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
- (FactoryDefinition *)definition \
{ \
    InitializerDefinition *initializerDefinition = [[InitializerDefinition alloc] initWithSelector:@selector(init) \
                                                                                        fieldNames:@[]]; \
    NSMutableDictionary *fieldDefinitions = [[NSMutableDictionary alloc] init]; \

#define assocField(__FIELD_NAME__, __CLASS__) \
    field(__FIELD_NAME__, [FactoryGentleman buildForObjectClass:__CLASS__.class])

#define field(__FIELD_NAME__, __FIELD_VALUE__) \
    [fieldDefinitions setObject:^{return (__FIELD_VALUE__); } forKey:f(__FIELD_NAME__)]

#define fieldBy(__FIELD_NAME__, __FIELD_BLOCK__) \
    [fieldDefinitions setObject:(__FIELD_BLOCK__) forKey:f(__FIELD_NAME__)]

#define initWith(__INITIALIZER__, ...) \
    initializerDefinition = [InitializerDefinition definitionWithSelector:@selector(__INITIALIZER__), ##__VA_ARGS__]

#define f(__FIELD_NAME__) @#__FIELD_NAME__

#define FactoryEnd \
    return [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition \
                                                   fieldDefinitions:fieldDefinitions]; \
} \
@end
