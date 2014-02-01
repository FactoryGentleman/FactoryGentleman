#import "FGInitializerDefinition.h"

@interface FGFactoryDefinition : NSObject
@property (nonatomic, readonly) FGInitializerDefinition *initializerDefinition;
@property (nonatomic, readonly) NSArray *fieldDefinitions;

- (instancetype)init __attribute__((unavailable("init not available ")));

- (instancetype)initWithInitializerDefinition:(FGInitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSArray *)fieldDefinitions;

- (instancetype)mergedWithDefinition:(FGFactoryDefinition *)otherDefinition;

- (NSArray *)initializerFieldDefinitions;

- (NSArray *)setterFieldDefinitions;
@end
