#import "FGDefinitionBuilder.h"

#import "FGFactoryGentleman.h"

SpecBegin(FGDefinitionBuilder)
    __block FGDefinitionBuilder *subject;
            
    __block id value;

    before(^{
        subject = [FGDefinitionBuilder builder];
        value = @"some value";
    });
            
    describe(@"-field:value:", ^{
        it(@"defines a field with value given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" value:value] build];
            id (^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            expect(fieldDefinition()).to.equal(value);
        });
    });

    describe(@"-field:by:", ^{
        it(@"defines a field with value define block given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" by:^{ return value; }] build];
            id (^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            expect(fieldDefinition()).to.equal(value);
        });
    });

    describe(@"-field:assoc:", ^{
        __block id factoryGentlemanClass;
        __block Class assocClass;

        before(^{
            assocClass = [NSString class];
            factoryGentlemanClass = [OCMockObject mockForClass:[FGFactoryGentleman class]];
            [[[factoryGentlemanClass stub] andReturn:value] buildForObjectClass:assocClass];
        });

        after(^{
            [factoryGentlemanClass stopMocking];
        });

        it(@"defines an associatve field with class given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" assoc:assocClass] build];
            id (^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            expect(fieldDefinition()).to.equal(value);
        });
    });

    describe(@"-field:assoc:trait:", ^{
        __block id factoryGentlemanClass;
        __block Class assocClass;
        __block NSString *trait;

        before(^{
            assocClass = [NSString class];
            trait = @"trait";
            factoryGentlemanClass = [OCMockObject mockForClass:[FGFactoryGentleman class]];
            [[[factoryGentlemanClass stub] andReturn:value] buildForObjectClass:assocClass trait:trait];
        });

        after(^{
            [factoryGentlemanClass stopMocking];
        });

        it(@"defines an associatve field with class and trait given", ^{
            FGFactoryDefinition *definition = [[subject field:@"field" assoc:assocClass trait:trait] build];
            id (^fieldDefinition)() = definition.fieldDefinitions[@"field"];
            expect(fieldDefinition).toNot.beNil();
            expect(fieldDefinition()).to.equal(value);
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
