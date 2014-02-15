#import "FGInitializerDefinition.h"

typedef id (^FGFieldDefinition)();

@interface FGFactoryDefinition : NSObject
@property (nonatomic, readonly) FGInitializerDefinition *initializerDefinition;
@property (nonatomic, readonly) NSDictionary *fieldDefinitions;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithInitializerDefinition:(FGInitializerDefinition *)initializerDefinition
                             fieldDefinitions:(NSDictionary *)fieldDefinitions;

- (instancetype)mergedWithDefinition:(FGFactoryDefinition *)otherDefinition;

- (NSOrderedSet *)initializerFieldDefinitions;
- (NSDictionary *)setterFieldDefinitions;
@end
