#import "FGNilValue.h"

SpecBegin(FGNilValue)
    describe(@"+nilValue", ^{
        it(@"returns a nil value", ^{
            expect([FGNilValue nilValue]).to.beKindOf([FGNilValue class]);
        });
    });
SpecEnd
