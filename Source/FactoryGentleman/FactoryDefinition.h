#import "InitializerDefinition.h"

@interface FactoryDefinition : NSObject
@property (nonatomic, readonly) InitializerDefinition *initializerDefinition;
@property (nonatomic, readonly) NSArray *fieldDefinitions;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithInitializerDefinition:(InitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSArray *)fieldDefinitions;

- (instancetype)mergedWithDefinition:(FactoryDefinition *)otherDefinition;

- (NSArray *)initializerFieldDefinitions;
- (NSArray *)setterFieldDefinitions;
@end
