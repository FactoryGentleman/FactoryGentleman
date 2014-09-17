#import "FGFactoryGentleman.h"

@interface BasicObject : NSObject
@property (nonatomic) NSString *string;
@property (nonatomic) NSString *extra;
@end

@implementation BasicObject
@end

FGFactoryBegin(BasicObject)
    [builder field:@"string" value:@"basic"];
    [builder field:@"extra" value:@"basic"];
    traitDefiners[@"different"] = ^(FGDefinitionBuilder *differentBuilder) {
        [differentBuilder field:@"extra" value:@"trait"];
    };
FGFactoryEnd

SpecBegin(FGFactoryGentleman)
    __block BasicObject *builtObject;

    describe(@"FGBuild", ^{
        before(^{
            builtObject = FGBuild([BasicObject class]);
        });

        it(@"builds an object from the definition", ^{
            expect(builtObject.string).to.equal(@"basic");
            expect(builtObject.extra).to.equal(@"basic");
        });
    });

    describe(@"FGBuildTrait", ^{
        before(^{
            builtObject = FGBuildTrait([BasicObject class], @"different");
        });

        it(@"builds an object from the trait definition", ^{
            expect(builtObject.string).to.equal(@"basic");
            expect(builtObject.extra).to.equal(@"trait");
        });
    });

    describe(@"FGBuildWith", ^{
        context(@"when definer is dictionary", ^{
            before(^{
                builtObject = FGBuildWith([BasicObject class], @{ @"string" : @"overriden" });
            });

            it(@"builds an object from the overriden definition", ^{
                expect(builtObject.string).to.equal(@"overriden");
                expect(builtObject.extra).to.equal(@"basic");
            });
        });

        context(@"when definer is block", ^{
            before(^{
                builtObject = FGBuildWith([BasicObject class], ^(FGDefinitionBuilder *builder) {
                    [builder field:@"string" value:@"overriden"];
                });
            });

            it(@"builds an object from the overriden definition", ^{
                expect(builtObject.string).to.equal(@"overriden");
                expect(builtObject.extra).to.equal(@"basic");
            });
        });
    });

    describe(@"FGBuildTraitWith", ^{
        context(@"when definer is dictionary", ^{
            before(^{
                builtObject = FGBuildTraitWith([BasicObject class], @"different", @{ @"string" : @"overriden" });
            });

            it(@"builds an object from the overriden trait definition", ^{
                expect(builtObject.string).to.equal(@"overriden");
                expect(builtObject.extra).to.equal(@"trait");
            });
        });

        context(@"when definer is block", ^{
            before(^{
                builtObject = FGBuildTraitWith([BasicObject class], @"different", ^(FGDefinitionBuilder *builder) {
                    [builder field:@"string" value:@"overriden"];
                });
            });

            it(@"builds an object from the overriden trait definition", ^{
                expect(builtObject.string).to.equal(@"overriden");
                expect(builtObject.extra).to.equal(@"trait");
            });
        });
    });
SpecEnd
