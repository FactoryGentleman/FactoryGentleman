#import "ObjectBuilder.h"

@interface ExampleMutableObject : NSObject
@property (nonatomic) NSString *mutableStringProperty;
@property (nonatomic) NSArray *mutableArrayProperty;
@property (nonatomic) int mutableIntProperty;
@end

@implementation ExampleMutableObject
@end

SpecBegin(ObjectBuilder)
    __block ObjectBuilder *subject;
    __block NSDictionary *overriddenFields;

    before(^{
        NSDictionary *definedFields = @{
                @"mutableStringProperty" : ^{ return @"some random string"; },
                @"mutableIntProperty" : ^{ return 3; },
                @"mutableArrayProperty" : ^{ return @[ @"random string in array" ]; },
                @"nonExistentProperty" : ^{ return @"this will never work"; }
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
SpecEnd
