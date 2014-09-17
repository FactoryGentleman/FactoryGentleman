#import "FGDefinitionBuilder.h"

#import "FGFactoryGentleman.h"

@interface FGDefinitionBuilder ()
@property (nonatomic, readonly) NSMutableDictionary *fieldDefinitions;
@property (nonatomic) id constructor;
@property (nonatomic) FGInitializerDefinition *initializerDefinition;
@end

@implementation FGDefinitionBuilder

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fieldDefinitions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (FGDefinitionBuilder *)builder
{
    return [[[self class] alloc] init];
}

#pragma mark - Definition

- (FGDefinitionBuilder *)field:(NSString *)fieldName boolValue:(BOOL)boolValue
{
    [self field:fieldName value:FGValue(boolValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName charValue:(char)charValue
{
    [self field:fieldName value:FGValue(charValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName intValue:(int)intValue
{
    [self field:fieldName value:FGValue(intValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName shortValue:(short)shortValue
{
    [self field:fieldName value:FGValue(shortValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName longValue:(long)longValue
{
    [self field:fieldName value:FGValue(longValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName longLongValue:(long long)longLongValue
{
    [self field:fieldName value:FGValue(longLongValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName integerValue:(NSInteger)integerValue
{
    [self field:fieldName value:FGValue(integerValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedCharValue:(unsigned char)unsignedCharValue
{
    [self field:fieldName value:FGValue(unsignedCharValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedIntValue:(unsigned int)unsignedIntValue
{
    [self field:fieldName value:FGValue(unsignedIntValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedShortValue:(unsigned short)unsignedShortValue
{
    [self field:fieldName value:FGValue(unsignedShortValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedLongValue:(unsigned long)unsignedLongValue
{
    [self field:fieldName value:FGValue(unsignedLongValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedLongLongValue:(unsigned long long)unsignedLongLongValue
{
    [self field:fieldName value:FGValue(unsignedLongLongValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName unsignedIntegerValue:(NSUInteger)unsignedIntegerValue
{
    [self field:fieldName value:FGValue(unsignedIntegerValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName floatValue:(float)floatValue
{
    [self field:fieldName value:FGValue(floatValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName doubleValue:(double)doubleValue
{
    [self field:fieldName value:FGValue(doubleValue)];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName value:(id)value
{
    [self.fieldDefinitions setObject:^{ return value; } forKey:fieldName];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName by:(id (^)())fieldValueBlock
{
    [self.fieldDefinitions setObject:fieldValueBlock
                              forKey:fieldName];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName assoc:(Class)fieldClass
{
    [self.fieldDefinitions setObject:^{ return FGBuild(fieldClass); }
                              forKey:fieldName];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName assoc:(Class)fieldClass trait:(NSString *)trait
{
    [self.fieldDefinitions setObject:^{ return FGBuildTrait(fieldClass, trait); }
                              forKey:fieldName];
    return self;
}

- (FGDefinitionBuilder *)initFrom:(id)constructor
{
    self.constructor = constructor;
    return self;
}

- (FGDefinitionBuilder *)initWith:(SEL)selector fieldNames:(NSArray *)fieldNames
{
    self.initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:selector
                                                                        fieldNames:[NSOrderedSet orderedSetWithArray:fieldNames]];
    return self;
}

#pragma mark - Building

- (FGFactoryDefinition *)build
{
    return [[FGFactoryDefinition alloc] initWithConstructor:self.constructor
                                      initializerDefinition:self.initializerDefinition
                                           fieldDefinitions:self.fieldDefinitions];
}

#pragma mark - Subscripting

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    [self field:(NSString *)key value:obj];
}

@end
