@interface FGInitializerDefinition : NSObject
@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) NSArray *fieldNames;

- (instancetype)init __attribute__((unavailable("init not available ")));

- (instancetype)initWithSelector:(SEL)selector
                      fieldNames:(NSArray *)fieldNames;

+ (instancetype)definitionWithSelector:(SEL)selector, ...;
@end
