#import "FactoryGentleman.h"

#import "User.h"

FactoryBegin(User)
    field(firstName, @"Bob");
    field(lastName, @"Bradley");
    assocField(address, Address);
    initWith(initWithFirstName:lastName:, f(firstName), f(lastName));
FactoryEnd
