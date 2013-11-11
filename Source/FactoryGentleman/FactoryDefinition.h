@interface FactoryDefinition : NSObject

@property (nonatomic, readonly) NSDictionary *fields;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithFields:(NSDictionary *)fields;

@end
