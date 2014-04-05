#import "FGFactoryDefinition.h"
#import "FGValue.h"

@interface FGFactoryDefiner : NSObject
- (instancetype)initWithObjectClass:(Class)objectClass;

- (void)registerDefinitions;

- (void)registerBaseDefinition:(FGFactoryDefinition *)baseDefinition
                 traitDefiners:(NSDictionary *)traitDefiners;
@end

#define FGFactoryBegin(__CLASS__) \
@interface __CLASS__##FGFactoryDefiner : FGFactoryDefiner \
@property (nonatomic, retain) Class class; \
@end \
@implementation __CLASS__##FGFactoryDefiner \
- (instancetype)init \
{ \
    self = [super initWithObjectClass:[__CLASS__ class]]; \
    return self; \
} \
- (void)registerDefinitions \
{ \
    FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:@selector(init) \
                                                                                            fieldNames:[NSOrderedSet orderedSet]]; \
    NSMutableDictionary *fieldDefinitions = [[NSMutableDictionary alloc] init]; \
    NSMutableDictionary *traitDefiners = [[NSMutableDictionary alloc] init]; \
    id constructor = nil;

#define FG_DefineBlock(__EXTRA_DEFINITION_BLOCK__) ^FGFactoryDefinition *{ \
    __block FGInitializerDefinition *initializerDefinition = nil; \
    __block id constructor = nil; \
    __block NSMutableDictionary *fieldDefinitions = [[NSMutableDictionary alloc] init]; \
    void (^defineBlock)() = __EXTRA_DEFINITION_BLOCK__; \
    defineBlock(); \
    return [[FGFactoryDefinition alloc] initWithConstructor:constructor \
                                      initializerDefinition:initializerDefinition \
                                           fieldDefinitions:fieldDefinitions]; \
}

#define FGTrait(__TRAIT_NAME__, __EXTRA_DEFINITION__BLOCK__) \
    [traitDefiners setObject:FG_DefineBlock(__EXTRA_DEFINITION__BLOCK__) forKey:FGF(__TRAIT_NAME__)]

#define FGAssocField(__FIELD_NAME__, __CLASS__) \
    FGField(__FIELD_NAME__, [FGFactoryGentleman buildForObjectClass:[__CLASS__ class]])

#define FGAssocFieldTrait(__FIELD_NAME__, __CLASS__, __TRAIT__) \
    FGField(__FIELD_NAME__, [FGFactoryGentleman buildForObjectClass:[__CLASS__ class] trait:FGF(__TRAIT__)])

#define FGField(__FIELD_NAME__, __FIELD_VALUE__) \
    [fieldDefinitions setObject:^id { return (__FIELD_VALUE__); } forKey:FGF(__FIELD_NAME__)]

#define FGFieldBy(__FIELD_NAME__, __FIELD_BLOCK__) \
    [fieldDefinitions setObject:__FIELD_BLOCK__ forKey:FGF(__FIELD_NAME__)]

#define FGInitFrom(__CONSTRUCTOR__) \
    constructor = __CONSTRUCTOR__

#define FGInitWith(__INITIALIZER__, ...) \
    initializerDefinition = [FGInitializerDefinition definitionWithSelector:@selector(__INITIALIZER__), ##__VA_ARGS__]

#define FGF(__FIELD_NAME__) @#__FIELD_NAME__

#define FGValue(__VALUE__) [FGValue value:&__VALUE__ withObjCType:@encode(__typeof__(__VALUE__))]

#define FGFactoryEnd \
    FGFactoryDefinition *baseDefinition = [[FGFactoryDefinition alloc] initWithConstructor:constructor \
                                                                     initializerDefinition:initializerDefinition \
                                                                          fieldDefinitions:fieldDefinitions]; \
    [self registerBaseDefinition:baseDefinition \
                   traitDefiners:traitDefiners]; \
} \
@end
