#import "FGFactoryGentleman.h"

#import "SimpleObject.h"

SpecBegin(FGFactoryGentleman)
    __block SimpleObject *builtObject;

    describe(@"FGBuild", ^{
        before(^{
            builtObject = FGBuild([SimpleObject class]);
        });

        it(@"builds an object from the definition", ^{
            expect(builtObject.first).to.equal(@"foo");
            expect(builtObject.second).to.equal(@"bar");
        });
    });

    describe(@"FGBuildTrait", ^{
        before(^{
            builtObject = FGBuildTrait([SimpleObject class], @"trait");
        });

        it(@"builds an object from the trait definition", ^{
            expect(builtObject.first).to.equal(@"foo");
            expect(builtObject.second).to.equal(@"hmm");
        });
    });

    describe(@"FGBuildWith", ^{
        context(@"when definer is dictionary", ^{
            before(^{
                builtObject = FGBuildWith([SimpleObject class], @{ @"first" : @"overriden" });
            });

            it(@"builds an object from the overriden definition", ^{
                expect(builtObject.first).to.equal(@"overriden");
                expect(builtObject.second).to.equal(@"bar");
            });
        });

        context(@"when definer is block", ^{
            before(^{
                builtObject = FGBuildWith([SimpleObject class], ^(FGDefinitionBuilder *builder) {
                    [builder field:@"first" value:@"overriden"];
                });
            });

            it(@"builds an object from the overriden definition", ^{
                expect(builtObject.first).to.equal(@"overriden");
                expect(builtObject.second).to.equal(@"bar");
            });
        });
    });

    describe(@"FGBuildTraitWith", ^{
        context(@"when definer is dictionary", ^{
            before(^{
                builtObject = FGBuildTraitWith([SimpleObject class], @"trait", @{ @"first" : @"overriden" });
            });

            it(@"builds an object from the overriden trait definition", ^{
                expect(builtObject.first).to.equal(@"overriden");
                expect(builtObject.second).to.equal(@"hmm");
            });
        });

        context(@"when definer is block", ^{
            before(^{
                builtObject = FGBuildTraitWith([SimpleObject class], @"trait", ^(FGDefinitionBuilder *builder) {
                    [builder field:@"first" value:@"overriden"];
                });
            });

            it(@"builds an object from the overriden trait definition", ^{
                expect(builtObject.first).to.equal(@"overriden");
                expect(builtObject.second).to.equal(@"hmm");
            });
        });
    });
SpecEnd
