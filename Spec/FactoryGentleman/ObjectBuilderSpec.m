#import "ObjectBuilder.h"

#import "Value.h"
#import "FieldDefinition.h"

@interface ExampleMutableObject : NSObject
@property (nonatomic) NSArray *mutableArrayProperty;
@property (nonatomic) int mutableIntProperty;
@end

@implementation ExampleMutableObject
@end

@interface ExampleImmutableObject : NSObject
@property (nonatomic, readonly) NSString *immutableStringProperty;
@property (nonatomic, readonly) float immutableFloatProperty;

- (instancetype)initWithImmutableStringProperty:(NSString *)immutableStringProperty
                         immutableFloatProperty:(float)immutableFloatProperty;
@end

@implementation ExampleImmutableObject

- (instancetype)initWithImmutableStringProperty:(NSString *)immutableStringProperty
                         immutableFloatProperty:(float)immutableFloatProperty
{
    self = [super init];
    if (self) {
        _immutableStringProperty = immutableStringProperty;
        _immutableFloatProperty = immutableFloatProperty;
    }
    return self;
}

@end

SpecBegin(ObjectBuilder)
    __block ObjectBuilder *subject;

    context(@"when building mutable objects", ^{
        before(^{
            Value *(^intProperty)() = ^{
                int intValue = 3;
                return [Value value:&intValue
                       withObjCType:@encode(__typeof__ (intValue))];
            };
            NSArray *(^arrayProperty)() = ^{ return @[@"random string in array"]; };
            NSArray *(^nonExistentProperty)() = ^{ return @[@"this will never work"]; };

            NSArray *definedFields = @[
                [FieldDefinition withFieldName:@"mutableIntProperty" definition:intProperty],
                [FieldDefinition withFieldName:@"mutableArrayProperty" definition:arrayProperty],
                [FieldDefinition withFieldName:@"nonExistentProperty" definition:nonExistentProperty]
            ];

            InitializerDefinition *initializerDefinition = [[InitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                                fieldNames:@[]];
            FactoryDefinition *definition = [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                                    fieldDefinitions:definedFields];
            subject = [[ObjectBuilder alloc] initWithObjectClass:ExampleMutableObject.class
                                                      definition:definition];
        });

        it(@"returns a new instance of the class", ^{
            expect([subject build]).to.beKindOf(ExampleMutableObject.class);
        });

        it(@"new instance has object values defined", ^{
            expect([[subject build] mutableArrayProperty]).to.equal(@[ @"random string in array" ]);
        });

        it(@"new instance has primitive values defined", ^{
            expect([[subject build] mutableIntProperty]).to.equal(3);
        });
    });

    context(@"when building immutable objects", ^{
        before(^{
            id (^stringProperty)() = ^id { return @"some cool string"; };
            id (^floatProperty)() = ^id {
                float floatValue = 3.5f;
                return [Value value:&floatValue
                       withObjCType:@encode(__typeof__ (floatValue))];
            };

            NSArray *definedFields = @[
                    [FieldDefinition withFieldName:@"immutableStringProperty" definition:stringProperty],
                    [FieldDefinition withFieldName:@"immutableFloatProperty" definition:floatProperty]
            ];

            SEL initializer = @selector(initWithImmutableStringProperty:immutableFloatProperty:);
            NSArray *fieldNames = @[ @"immutableStringProperty", @"immutableFloatProperty" ];
            InitializerDefinition *initializerDefinition = [[InitializerDefinition alloc] initWithSelector:initializer
                                                                                                fieldNames:fieldNames];
            FactoryDefinition *definition = [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                                    fieldDefinitions:definedFields];
            subject = [[ObjectBuilder alloc] initWithObjectClass:ExampleImmutableObject.class
                                                      definition:definition];
        });

        it(@"returns a new instance of the class", ^{
            expect([subject build]).to.beKindOf(ExampleImmutableObject.class);
        });

        it(@"new instance has object values defined", ^{
            expect([[subject build] immutableStringProperty]).to.equal(@"some cool string");
        });

        it(@"new instance has primitive values defined", ^{
            expect([[subject build] immutableFloatProperty]).to.equal(3.5f);
        });
    });
SpecEnd
