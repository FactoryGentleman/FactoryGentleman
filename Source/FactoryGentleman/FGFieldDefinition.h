@interface FGFieldDefinition : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) id (^definition)();

- (instancetype)init __attribute__((unavailable("init not available ")));

+ (instancetype)withFieldName:(NSString *)name definition:(id (^)())definition;
@end
