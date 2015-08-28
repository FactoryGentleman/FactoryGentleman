#import <Foundation/Foundation.h>

#import "FGFactoryDefiner.h"

@interface FGDefinitionBuilder : NSObject
+ (instancetype)builder;

- (instancetype)nilField:(NSString *)fieldName;
- (instancetype)field:(NSString *)fieldName boolValue:(BOOL)boolValue;
- (instancetype)field:(NSString *)fieldName charValue:(char)charValue;
- (instancetype)field:(NSString *)fieldName intValue:(int)intValue;
- (instancetype)field:(NSString *)fieldName shortValue:(short)shortValue;
- (instancetype)field:(NSString *)fieldName longValue:(long)longValue;
- (instancetype)field:(NSString *)fieldName longLongValue:(long long)longLongValue;
- (instancetype)field:(NSString *)fieldName integerValue:(NSInteger)integerValue;
- (instancetype)field:(NSString *)fieldName unsignedCharValue:(unsigned char)unsignedCharValue;
- (instancetype)field:(NSString *)fieldName unsignedIntValue:(unsigned int)unsignedIntValue;
- (instancetype)field:(NSString *)fieldName unsignedShortValue:(unsigned short)unsignedShortValue;
- (instancetype)field:(NSString *)fieldName unsignedLongValue:(unsigned long)unsignedLongValue;
- (instancetype)field:(NSString *)fieldName unsignedLongLongValue:(unsigned long long)unsignedLongLongValue;
- (instancetype)field:(NSString *)fieldName unsignedIntegerValue:(NSUInteger)unsignedIntegerValue;
- (instancetype)field:(NSString *)fieldName floatValue:(float)floatValue;
- (instancetype)field:(NSString *)fieldName doubleValue:(double)doubleValue;
- (instancetype)field:(NSString *)fieldName value:(id)value;
- (instancetype)field:(NSString *)fieldName by:(id (^)())fieldValueBlock;
- (instancetype)field:(NSString *)fieldName assoc:(Class)fieldClass;
- (instancetype)field:(NSString *)fieldName assoc:(Class)fieldClass with:(id)definer;
- (instancetype)field:(NSString *)fieldName assoc:(Class)fieldClass trait:(NSString *)trait;
- (instancetype)field:(NSString *)fieldName assoc:(Class)fieldClass trait:(NSString *)trait with:(id)definer;

- (instancetype)initFrom:(id)constructor;
- (instancetype)initWith:(SEL)selector fieldNames:(NSArray *)fieldNames;

- (FGFactoryDefinition *)build;

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;
@end

#define FGValue(__VALUE__) \
    [FGValue value:&__VALUE__ withObjCType:@encode(__typeof__(__VALUE__))]

#define FGNil \
    [FGNilValue nilValue]
