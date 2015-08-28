#import <Foundation/Foundation.h>

#import "FGFactoryDefinitionRegistry.h"
#import "FGFactoryDefinition.h"
#import "FGDefinitionBuilder.h"
#import "FGNilValue.h"
#import "FGValue.h"

@interface FGFactoryDefiner : NSObject
@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, readonly) FGFactoryDefinitionRegistry *factoryDefinitionRegistry;

- (instancetype)initWithObjectClass:(Class)objectClass;

- (void)registerDefinitions;

- (void)registerBaseDefinition:(FGFactoryDefinition *)baseDefinition
                 traitDefiners:(NSDictionary *)traitDefiners;

- (void)registerBaseDefinition:(FGFactoryDefinition *)baseDefinition;
- (void)registerTraitDefiner:(NSString *)trait traitDefiner:(id)traitDefiner;

+ (void)loadFactoryDefiners;
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
