@interface FactoryDefinition : NSObject

@property (nonatomic, readonly) NSDictionary *fieldDefinitions;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithFieldDefinitions:(NSDictionary *)fieldDefinitions;

@end
