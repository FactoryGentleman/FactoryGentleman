#import "FactoryGentleman.h"

#import "Address.h"

FGFactoryBegin(Address)
    FGField(houseNumber, @"123");
    FGField(street, @"Important Street");
    FGField(city, @"New York City");
FGFactoryEnd
