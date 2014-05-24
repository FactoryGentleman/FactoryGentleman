#import <FactoryGentleman/FGObjectBuilder.h>

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

@interface ExampleImmutableObjectCreator : NSObject
+ (ExampleImmutableObject *)exampleImmutableObjectWithFloat:(float)immutableFloatProperty;
@end

@implementation ExampleImmutableObjectCreator

+ (ExampleImmutableObject *)exampleImmutableObjectWithFloat:(float)immutableFloatProperty
{
    return [[ExampleImmutableObject alloc] initWithImmutableStringProperty:@"some sort of string"
                                                    immutableFloatProperty:immutableFloatProperty];
}

@end

SpecBegin(FGObjectBuilder)
    __block FGObjectBuilder *subject;

    context(@"when building mutable objects", ^{
        before(^{
            FGValue *(^intProperty)() = ^{
                int intValue = 3;
                return [FGValue value:&intValue
                         withObjCType:@encode(__typeof__ (intValue))];
            };
            NSArray *(^arrayProperty)() = ^{ return @[@"random string in array"]; };
            NSArray *(^nonExistentProperty)() = ^{ return @[@"this will never work"]; };

            NSDictionary *definedFields = @{
                    @"mutableIntProperty" : intProperty,
                    @"mutableArrayProperty" : arrayProperty,
                    @"nonExistentProperty" : nonExistentProperty
            };

            FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:@selector(init)
                                                                                                    fieldNames:[NSOrderedSet orderedSet]];
            FGFactoryDefinition *definition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                                         initializerDefinition:initializerDefinition
                                                                              fieldDefinitions:definedFields];
            subject = [[FGObjectBuilder alloc] initWithObjectClass:[ExampleMutableObject class]
                                                          readonly:NO
                                                        definition:definition];
        });

        it(@"returns a new instance of the class", ^{
            expect([subject build]).to.beKindOf([ExampleMutableObject class]);
        });

        it(@"new instance has object values defined", ^{
            expect([[subject build] mutableArrayProperty]).to.equal(@[ @"random string in array" ]);
        });

        it(@"new instance has primitive values defined", ^{
            expect([[subject build] mutableIntProperty]).to.equal(3);
        });
    });

    context(@"when building immutable objects", ^{
        __block id (^stringProperty)();
        __block id (^floatProperty)();
        __block NSDictionary *definedFields;

        before(^{
            stringProperty = ^id { return @"some cool string"; };
            floatProperty = ^id {
                float floatValue = 3.5f;
                return [FGValue value:&floatValue
                         withObjCType:@encode(__typeof__ (floatValue))];
            };

            definedFields = @{
                            @"immutableStringProperty" : stringProperty,
                            @"immutableFloatProperty" : floatProperty
                    };
        });

        context(@"when setting read only properties", ^{
            before(^{
                FGFactoryDefinition *definition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                                             initializerDefinition:nil
                                                                                  fieldDefinitions:definedFields];
                subject = [[FGObjectBuilder alloc] initWithObjectClass:[ExampleImmutableObject class]
                                                              readonly:YES
                                                            definition:definition];
            });

            it(@"returns a new instance of the class", ^{
                expect([subject build]).to.beKindOf([ExampleImmutableObject class]);
            });

            it(@"new instance has object values defined", ^{
                expect([[subject build] immutableStringProperty]).to.equal(@"some cool string");
            });
        });

        context(@"when NOT setting read only properties", ^{
            before(^{
                SEL initializer = @selector(initWithImmutableStringProperty:immutableFloatProperty:);
                NSOrderedSet *fieldNames = [NSOrderedSet orderedSetWithArray:@[ @"immutableStringProperty", @"immutableFloatProperty" ]];
                FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:initializer
                                                                                                        fieldNames:fieldNames];
                FGFactoryDefinition *definition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                                             initializerDefinition:initializerDefinition
                                                                                  fieldDefinitions:definedFields];
                subject = [[FGObjectBuilder alloc] initWithObjectClass:[ExampleImmutableObject class]
                                                              readonly:NO
                                                            definition:definition];
            });

            it(@"returns a new instance of the class", ^{
                expect([subject build]).to.beKindOf([ExampleImmutableObject class]);
            });

            it(@"new instance has object values defined", ^{
                expect([[subject build] immutableStringProperty]).to.equal(@"some cool string");
            });

            it(@"new instance has primitive values defined", ^{
                expect([[subject build] immutableFloatProperty]).to.equal(3.5f);
            });
        });
    });

    context(@"when building objects using constructors", ^{
        before(^{
            SEL initializer = @selector(exampleImmutableObjectWithFloat:);
            id (^floatProperty)() = ^id {
                float floatValue = 1.2f;
                return [FGValue value:&floatValue
                         withObjCType:@encode(__typeof__ (floatValue))];
            };

            NSDictionary *definedFields = @{ @"immutableFloatProperty" : floatProperty };
            NSOrderedSet *fieldNames = [NSOrderedSet orderedSetWithObject:@"immutableFloatProperty"];
            FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:initializer
                                                                                                    fieldNames:fieldNames];
            FGFactoryDefinition *definition = [[FGFactoryDefinition alloc] initWithConstructor:ExampleImmutableObjectCreator.class
                                                                         initializerDefinition:initializerDefinition
                                                                              fieldDefinitions:definedFields];
            subject = [[FGObjectBuilder alloc] initWithObjectClass:[ExampleImmutableObject class]
                                                          readonly:NO
                                                        definition:definition];
        });

        it(@"returns a new instance of the class", ^{
            expect([subject build]).to.beKindOf([ExampleImmutableObject class]);
        });

        it(@"new instance has object values defined", ^{
            expect([[subject build] immutableStringProperty]).to.equal(@"some sort of string");
        });

        it(@"new instance has primitive values defined", ^{
            expect([[subject build] immutableFloatProperty]).to.equal(1.2f);
        });
    });
SpecEnd
