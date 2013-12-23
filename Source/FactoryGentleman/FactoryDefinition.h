#import "InitializerDefinition.h"

@interface FactoryDefinition : NSObject
@property (nonatomic, readonly) InitializerDefinition *initializerDefinition;
@property (nonatomic, readonly) NSDictionary *fieldDefinitions;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithInitializerDefinition:(InitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSDictionary *)fieldDefinitions;

- (instancetype)mergedWithDefinition:(FactoryDefinition *)otherDefinition;

- (NSDictionary *)initializerFieldDefinitions;
- (NSDictionary *)setterFieldDefinitions;
@end
