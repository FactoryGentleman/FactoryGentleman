#import "FGFactoryDefiner.h"

@interface FGDefinitionBuilder : NSObject
+ (FGDefinitionBuilder *)builder;

- (FGDefinitionBuilder *)field:(NSString *)fieldName boolValue:(BOOL)boolValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName charValue:(char)charValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName intValue:(int)intValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName shortValue:(short)shortValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName longValue:(long)longValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName longLongValue:(long long)longLongValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName integerValue:(NSInteger)integerValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedCharValue:(unsigned char)unsignedCharValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedIntValue:(unsigned int)unsignedIntValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedShortValue:(unsigned short)unsignedShortValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedLongValue:(unsigned long)unsignedLongValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedLongLongValue:(unsigned long long)unsignedLongLongValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedIntegerValue:(NSUInteger)unsignedIntegerValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName floatValue:(float)floatValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName doubleValue:(double)doubleValue;
- (FGDefinitionBuilder *)field:(NSString *)fieldName value:(id)value;
- (FGDefinitionBuilder *)field:(NSString *)fieldName by:(id (^)())fieldValueBlock;
- (FGDefinitionBuilder *)field:(NSString *)fieldName assoc:(Class)fieldClass;
- (FGDefinitionBuilder *)field:(NSString *)fieldName assoc:(Class)fieldClass trait:(NSString *)trait;

- (FGDefinitionBuilder *)initFrom:(id)constructor;
- (FGDefinitionBuilder *)initWith:(SEL)selector fieldNames:(NSArray *)fieldNames;

- (FGFactoryDefinition *)build;

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;
@end

#define FGValue(__VALUE__) \
    [FGValue value:&__VALUE__ withObjCType:@encode(__typeof__(__VALUE__))]

#define FGNil \
    [FGNilValue nilValue]
