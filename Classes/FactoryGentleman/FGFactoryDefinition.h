#import "FGInitializerDefinition.h"

typedef id (^FGFieldDefinition)();

@interface FGFactoryDefinition : NSObject
@property (nonatomic, readonly) id constructor;
@property (nonatomic, readonly) FGInitializerDefinition *initializerDefinition;
@property (nonatomic, readonly) NSDictionary *fieldDefinitions;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithConstructor:(id)constructor
              initializerDefinition:(FGInitializerDefinition *)initializerDefinition
                   fieldDefinitions:(NSDictionary *)fieldDefinitions;

- (instancetype)mergedWithDefinition:(id)other;

- (NSOrderedSet *)initializerFieldDefinitions;
- (NSDictionary *)setterFieldDefinitions;
@end
