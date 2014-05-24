@interface FGInitializerDefinition : NSObject
@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) NSOrderedSet *fieldNames;

- (instancetype)init __attribute__((unavailable("init not available ")));
- (instancetype)initWithSelector:(SEL)selector
                      fieldNames:(NSOrderedSet *)fieldNames;

+ (instancetype)definitionWithSelector:(SEL)selector, ...;
@end
