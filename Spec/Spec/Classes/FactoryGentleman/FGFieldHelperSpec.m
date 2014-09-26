#import "FGFieldHelper.h"

SpecBegin(FGFieldHelper)
    describe(@"+setterForField:", ^{
        it(@"returns a selector with the standard setter name for the field", ^{
            expect(NSStringFromSelector([FGFieldHelper setterForField:@"someField"])).to.equal(@"setSomeField:");
        });
    });
SpecEnd
