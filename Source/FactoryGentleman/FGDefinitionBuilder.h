#import "FGFactoryDefiner.h"

@interface FGDefinitionBuilder : NSObject
+ (FGDefinitionBuilder *)builder;

- (FGDefinitionBuilder *)field:(NSString *)fieldName value:(id)value;
- (FGDefinitionBuilder *)field:(NSString *)fieldName by:(id (^)())fieldValueBlock;
- (FGDefinitionBuilder *)field:(NSString *)fieldName assoc:(Class)fieldClass;
- (FGDefinitionBuilder *)field:(NSString *)fieldName assoc:(Class)fieldClass trait:(NSString *)trait;

- (FGDefinitionBuilder *)initFrom:(id)constructor;
- (FGDefinitionBuilder *)initWith:(SEL)selector fieldNames:(NSArray *)fieldNames;

- (FGFactoryDefinition *)build;
@end
