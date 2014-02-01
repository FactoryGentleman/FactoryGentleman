#import "FGFactoryDefinition.h"
#import "FGFieldDefinition.h"
#import "FGValue.h"

@interface FGFactoryDefiner : NSObject
- (instancetype)init __attribute__((unavailable("init not available ")));

- (instancetype)initWithObjectClass:(Class)objectClass;

- (FGFactoryDefinition *)definition;
@end

#define FGFactoryBegin(__CLASS__) \
@interface __CLASS__##FGFactoryDefiner : FGFactoryDefiner \
@property (nonatomic, retain) Class class; \
@end \
@implementation __CLASS__##FGFactoryDefiner \
- (instancetype)init \
{ \
    self = [super initWithObjectClass:__CLASS__.class]; \
    return self; \
} \
- (FGFactoryDefinition *)definition \
{ \
    FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:@selector(init) \
                                                                                            fieldNames:@[]]; \
    NSMutableArray *fieldDefinitions = [[NSMutableArray alloc] init]; \

#define FGAssocField(__FIELD_NAME__, __CLASS__) \
    FGField(__FIELD_NAME__, [FGFactoryGentleman buildForObjectClass:__CLASS__.class])

#define FGField(__FIELD_NAME__, __FIELD_VALUE__) \
    [fieldDefinitions addObject:[FGFieldDefinition withFieldName:FGF(__FIELD_NAME__) \
                                                      definition:^id { return (__FIELD_VALUE__); }]]

#define FGFieldBy(__FIELD_NAME__, __FIELD_BLOCK__) \
    [fieldDefinitions addObject:[FGFieldDefinition withFieldName:FGF(__FIELD_NAME__) \
                                                      definition:(__FIELD_BLOCK__)]]

#define FGInitWith(__INITIALIZER__, ...) \
    initializerDefinition = [FGInitializerDefinition definitionWithSelector:@selector(__INITIALIZER__), ##__VA_ARGS__]

#define FGF(__FIELD_NAME__) @#__FIELD_NAME__

#define FGValue(__VALUE__) [FGValue value:&__VALUE__ withObjCType:@encode(__typeof__(__VALUE__))]

#define FGFactoryEnd \
    return [[FGFactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition \
                                                     fieldDefinitions:fieldDefinitions]; \
} \
@end
