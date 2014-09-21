#import "SimpleObject.h"

#import "FGFactoryDefiner.h"

FGFactoryBegin(SimpleObject)
    builder[@"first"] = @"foo";
    builder[@"second"] = @"bar";
    traitDefiners[@"trait"] = ^(FGDefinitionBuilder *traitBuilder) {
        traitBuilder[@"second"] = @"hmm";
    };
FGFactoryEnd
