#import "FGFactoryDefinition.h"
#import "FGDefinitionBuilder.h"
#import "FGNilValue.h"
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
    FGDefinitionBuilder *builder = [FGDefinitionBuilder builder]; \
    NSMutableDictionary *traitDefiners = [[NSMutableDictionary alloc] init]; \

#define FGFactoryEnd \
    [self registerBaseDefinition:[builder build] \
                   traitDefiners:traitDefiners]; \
} \
\
@end
