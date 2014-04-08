#import "FGDefinitionBuilder.h"

#import "FGFactoryGentleman.h"

@interface FGDefinitionBuilder ()
@property (nonatomic, readonly) NSMutableDictionary *fieldDefinitions;
@property (nonatomic, readonly) NSMutableDictionary *traitDefiners;
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
        _traitDefiners = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (FGDefinitionBuilder *)builder
{
    return [[[self class] alloc] init];
}

#pragma mark - Definition

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
    [self.fieldDefinitions setObject:^{ return [FGFactoryGentleman buildForObjectClass:fieldClass]; }
                              forKey:fieldName];
    return self;
}

- (FGDefinitionBuilder *)field:(NSString *)fieldName assoc:(Class)fieldClass trait:(NSString *)trait
{
    [self.fieldDefinitions setObject:^{ return [FGFactoryGentleman buildForObjectClass:fieldClass trait:trait]; }
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

- (FGFactoryDefinition *)build
{
    return [[FGFactoryDefinition alloc] initWithConstructor:self.constructor
                                      initializerDefinition:self.initializerDefinition
                                           fieldDefinitions:self.fieldDefinitions];
}

@end
