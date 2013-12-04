#import "ObjectBuilder.h"

@interface ExampleMutableObject : NSObject
@property (nonatomic) NSString *mutableStringProperty;
@property (nonatomic) NSArray *mutableArrayProperty;
@property (nonatomic) int mutableIntProperty;
@end

@implementation ExampleMutableObject
@end

@interface ExampleImmutableObject : NSObject
@property (nonatomic, readonly) NSString *immutableStringProperty;
@property (nonatomic, readonly) NSNumber *immutableNumberProperty;
@property (nonatomic, readonly) float immutableFloatProperty;

- (instancetype)initWithImmutableStringProperty:(NSString *)immutableStringProperty
                        immutableNumberProperty:(NSNumber *)immutableNumberProperty
                         immutableFloatProperty:(float)immutableFloatProperty;
@end

@implementation ExampleImmutableObject

- (instancetype)initWithImmutableStringProperty:(NSString *)immutableStringProperty
                        immutableNumberProperty:(NSNumber *)immutableNumberProperty
                         immutableFloatProperty:(float)immutableFloatProperty
{
    self = [super init];
    if (self) {
        _immutableStringProperty = immutableStringProperty;
        _immutableNumberProperty = immutableNumberProperty;
        _immutableFloatProperty = immutableFloatProperty;
    }
    return self;
}

@end

SpecBegin(ObjectBuilder)
    __block ObjectBuilder *subject;
    __block NSDictionary *overriddenFields;

    context(@"when building mutable objects", ^{
        before(^{
            NSDictionary *definedFields = @{
                    @"mutableStringProperty" : ^{ return @"some random string"; },
                    @"mutableIntProperty"    : ^{ return 3; },
                    @"mutableArrayProperty"  : ^{ return @[ @"random string in array" ]; },
                    @"nonExistentProperty"   : ^{ return @"this will never work"; }
            };
            InitializerDefinition *initializerDefinition = [[InitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                                fieldNames:@[]];
            FactoryDefinition *definition = [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                                    fieldDefinitions:definedFields];
            subject = [[ObjectBuilder alloc] initWithObjectClass:ExampleMutableObject.class
                                                      definition:definition];
            overriddenFields = @{
                    @"mutableStringProperty" : ^{ return @"totally new value"; }
            };
        });

        it(@"returns a new instance of the class", ^{
            expect([subject buildWithFieldDefinitions:overriddenFields]).to.beKindOf(ExampleMutableObject.class);
        });

        it(@"new instance has object values defined", ^{
            expect([[subject buildWithFieldDefinitions:overriddenFields] mutableArrayProperty]).to.equal(@[ @"random string in array" ]);
        });

        it(@"new instance has primitive values defined", ^{
            expect([[subject buildWithFieldDefinitions:overriddenFields] mutableIntProperty]).to.equal(3);
        });

        it(@"overrides defined fields with the field definitions given", ^{
            expect([[subject buildWithFieldDefinitions:overriddenFields] mutableStringProperty]).to.equal(@"totally new value");
        });
    });

    context(@"when building immutable objects", ^{
        before(^{
            NSDictionary *definedFields = @{
                    @"immutableStringProperty" : ^{ return @"some cool string"; },
                    @"immutableNumberProperty" : ^{ return @321; },
                    @"immutableFloatProperty"  : ^{ return 3.5f; }
            };

            SEL initializer = @selector(initWithImmutableStringProperty:immutableNumberProperty:immutableFloatProperty:);
            NSArray *fieldNames = @[ @"immutableStringProperty", @"immutableNumberProperty", @"immutableFloatProperty" ];
            InitializerDefinition *initializerDefinition = [[InitializerDefinition alloc] initWithSelector:initializer
                                                                                                fieldNames:fieldNames];
            FactoryDefinition *definition = [[FactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                                    fieldDefinitions:definedFields];
            subject = [[ObjectBuilder alloc] initWithObjectClass:ExampleImmutableObject.class
                                                      definition:definition];
            overriddenFields = @{
                    @"immutableNumberProperty" : ^{ return @666; }
            };
        });

        it(@"returns a new instance of the class", ^{
            expect([subject buildWithFieldDefinitions:overriddenFields]).to.beKindOf(ExampleImmutableObject.class);
        });

        it(@"new instance has object values defined", ^{
            expect([[subject buildWithFieldDefinitions:overriddenFields] immutableStringProperty]).to.equal(@"some cool string");
        });

        it(@"new instance has primitive values defined", ^{
            expect([[subject buildWithFieldDefinitions:overriddenFields] immutableFloatProperty]).to.equal(3.5f);
        });

        it(@"overrides defined fields with the field definitions given", ^{
            expect([[subject buildWithFieldDefinitions:overriddenFields] immutableNumberProperty]).to.equal(@666);
        });
    });
SpecEnd
