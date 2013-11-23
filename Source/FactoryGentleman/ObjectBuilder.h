#import "FactoryDefinition.h"

@interface ObjectBuilder : NSObject

@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, readonly) FactoryDefinition *definition;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithObjectClass:(Class)objectClass
                         definition:(FactoryDefinition *)definition;

- (id)buildWithFieldDefinitions:(NSDictionary *)fieldDefinitions;

@end
