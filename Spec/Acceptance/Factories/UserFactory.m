#import "FGFactoryGentleman.h"

#import "User.h"

FGFactoryBegin(User)
    __block int currentId = 0;
    FGFieldBy(resourceId, ^{
        return @(++currentId);
    });
    FGField(firstName, @"Bob");
    FGField(lastName, @"Bradley");
    NSUInteger friendCount = 3;
    FGField(friendCount, FGValue(friendCount));
    FGAssocField(address, Address);
    FGTrait(homeless, ^{
        FGField(address, nil);
    });
    FGInitWith(initWithFirstName:lastName:, FGF(firstName), FGF(lastName));
FGFactoryEnd
