#import "FactoryGentleman.h"

#import "User.h"

FactoryBegin(User)
    __block int currentId = 0;
    fieldBy(resourceId, ^{
        return @(++currentId);
    });
    field(firstName, @"Bob");
    field(lastName, @"Bradley");
    NSUInteger friendCount = 3;
    field(friendCount, value(friendCount));
    assocField(address, Address);
    initWith(initWithFirstName:lastName:, f(firstName), f(lastName));
FactoryEnd
