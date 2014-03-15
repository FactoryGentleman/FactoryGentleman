#import "FGObjectBuilder.h"

#import "FGValue.h"

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
            FGFactoryDefinition *definition = [[FGFactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                                        fieldDefinitions:definedFields];
            subject = [[FGObjectBuilder alloc] initWithObjectClass:[ExampleMutableObject class]
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
        before(^{
            id (^stringProperty)() = ^id { return @"some cool string"; };
            id (^floatProperty)() = ^id {
                float floatValue = 3.5f;
                return [FGValue value:&floatValue
                         withObjCType:@encode(__typeof__ (floatValue))];
            };

            NSDictionary *definedFields = @{
                    @"immutableStringProperty" : stringProperty,
                    @"immutableFloatProperty" : floatProperty
            };

            SEL initializer = @selector(initWithImmutableStringProperty:immutableFloatProperty:);
            NSOrderedSet *fieldNames = [NSOrderedSet orderedSetWithArray:@[ @"immutableStringProperty", @"immutableFloatProperty" ]];
            FGInitializerDefinition *initializerDefinition = [[FGInitializerDefinition alloc] initWithSelector:initializer
                                                                                                    fieldNames:fieldNames];
            FGFactoryDefinition *definition = [[FGFactoryDefinition alloc] initWithInitializerDefinition:initializerDefinition
                                                                                        fieldDefinitions:definedFields];
            subject = [[FGObjectBuilder alloc] initWithObjectClass:[ExampleImmutableObject class]
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
SpecEnd
