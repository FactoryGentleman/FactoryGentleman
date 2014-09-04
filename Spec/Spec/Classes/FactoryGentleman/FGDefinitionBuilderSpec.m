#import "FGDefinitionBuilder.h"

FGFactoryBegin(NSString)
    traitDefiners[@"trait"] = ^(FGDefinitionBuilder *traitBuilder) {};
FGFactoryEnd

SpecBegin(FGDefinitionBuilder)
    __block FGDefinitionBuilder *subject;
            
    before(^{
        subject = [FGDefinitionBuilder builder];
    });
            
    describe(@"-field:boolValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" boolValue:YES] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            BOOL value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(YES);
        });
    });

    describe(@"-field:charValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" charValue:'c'] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            char value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal('c');
        });
    });

    describe(@"-field:intValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" intValue:2] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            int value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(2);
        });
    });

    describe(@"-field:shortValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" shortValue:3] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            short value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(3);
        });
    });

    describe(@"-field:longValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" longValue:4] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            long value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(4);
        });
    });

    describe(@"-field:longLongValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" longLongValue:5] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            long long value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(5);
        });
    });

    describe(@"-field:integerValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" integerValue:6] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            NSInteger value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(6);
        });
    });

    describe(@"-field:unsignedCharValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" unsignedCharValue:'e'] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            unsigned char value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal('e');
        });
    });

    describe(@"-field:unsignedIntValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" unsignedIntValue:7] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            unsigned int value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(7);
        });
    });

    describe(@"-field:unsignedShortValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" unsignedShortValue:8] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            unsigned short value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(8);
        });
    });

    describe(@"-field:unsignedLongValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" unsignedLongValue:9] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            unsigned long value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(9);
        });
    });

    describe(@"-field:unsignedLongLongValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" unsignedLongLongValue:10] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            unsigned long long value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(10);
        });
    });

    describe(@"-field:unsignedIntegerValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" unsignedIntegerValue:11] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            NSUInteger value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(11);
        });
    });

    describe(@"-field:floatValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" floatValue:1.1] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            float value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(1.1);
        });
    });

    describe(@"-field:doubleValue:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" doubleValue:1.2] build];
            FGValue *(^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            double value;
            [fieldDefinition().wrappedValue getValue:&value];
            expect(value).to.equal(1.2);
        });
    });

    describe(@"-field:value:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" value:@"value"] build];
            id (^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            expect(fieldDefinition()).to.equal(@"value");
        });
    });

    describe(@"-field:by:", ^{
        it(@"defines a field with value define block given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" by:^{ return @"value"; }] build];
            id (^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            expect(fieldDefinition()).to.equal(@"value");
        });
    });

    describe(@"-field:assoc:", ^{
        __block Class assocClass;

        before(^{
            assocClass = [NSString class];
        });

        it(@"defines an associatve field with class given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" assoc:assocClass] build];
            id (^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            expect(fieldDefinition()).to.equal(@"");
        });
    });

    describe(@"-field:assoc:trait:", ^{
        __block Class assocClass;
        __block NSString *trait;

        before(^{
            assocClass = [NSString class];
            trait = @"trait";
        });

        it(@"defines an associatve field with class and trait given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" assoc:assocClass trait:trait] build];
            id (^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            expect(fieldDefinition()).to.equal(@"");
        });
    });

    describe(@"-initFrom:", ^{
        __block Class constructor;

        before(^{
            constructor = [NSString class];
        });

        it(@"defines the constructor given", ^{
            FGFactoryDefinition *definition = [[subject initFrom:constructor] build];
            expect(definition.constructor).to.equal(constructor);
        });
    });

    describe(@"-initWith:", ^{
        __block SEL selector;
        __block NSArray *fieldNames;

        before(^{
            selector = @selector(initWithUUIDString:);
            fieldNames = @[ @"foo", @"bar" ];
        });

        it(@"defines the initializer selector given", ^{
            FGFactoryDefinition *definition = [[subject initWith:selector fieldNames:fieldNames] build];
            expect(definition.initializerDefinition.selector).to.equal(selector);
        });

        it(@"defines the initializer fields given", ^{
            FGFactoryDefinition *definition = [[subject initWith:selector fieldNames:fieldNames] build];
            expect(definition.initializerDefinition.fieldNames).to.equal([NSOrderedSet orderedSetWithArray:fieldNames]);
        });
    });
SpecEnd
