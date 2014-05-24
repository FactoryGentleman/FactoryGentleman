#import "FGFactoryDefinition.h"

@interface FGObjectBuilder : NSObject
@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, readonly) BOOL readonly;
@property (nonatomic, readonly) FGFactoryDefinition *definition;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithObjectClass:(Class)objectClass
                           readonly:(BOOL)readonly
                         definition:(FGFactoryDefinition *)definition;

- (id)build;
@end
