#import "FactoryGentleman.h"

#import "Address.h"

FactoryBegin(Address)
    field(houseNumber, @"123");
    field(street, @"Important Street");
    field(city, @"New York City");
FactoryEnd
