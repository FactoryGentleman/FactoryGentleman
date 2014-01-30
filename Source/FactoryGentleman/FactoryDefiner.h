#import "FactoryDefinition.h"
#import "FieldDefinition.h"
#import "Value.h"

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
    NSMutableArray *fieldDefinitions = [[NSMutableArray alloc] init]; \

#define assocField(__FIELD_NAME__, __CLASS__) \
    field(__FIELD_NAME__, [FactoryGentleman buildForObjectClass:__CLASS__.class])

#define field(__FIELD_NAME__, __FIELD_VALUE__) \
    [fieldDefinitions addObject:[FieldDefinition withFieldName:f(__FIELD_NAME__) \
                                                    definition:^id { return (__FIELD_VALUE__); }]]

#define fieldBy(__FIELD_NAME__, __FIELD_BLOCK__) \
    [fieldDefinitions addObject:[FieldDefinition withFieldName:f(__FIELD_NAME__) \
                                                    definition:(__FIELD_BLOCK__)]]

#define initWith(__INITIALIZER__, ...) \
    initializerDefinition = [InitializerDefinition definitionWithSelector:@selector(__INITIALIZER__), ##__VA_ARGS__]

#define f(__FIELD_NAME__) @#__FIELD_NAME__

#define value(__VALUE__) [Value value:&__VALUE__ withObjCType:@encode(__typeof__(__VALUE__))]

#define FactoryEnd \
    return [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition \
                                                   fieldDefinitions:fieldDefinitions]; \
} \
@end
