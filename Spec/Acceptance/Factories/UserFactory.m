#import "FactoryGentleman.h"

#import "User.h"

FGFactoryBegin(User)
    __block NSUInteger currentId = 0;
    [builder field:@"resourceId" by:^{
        return @(++currentId);
    }];
    [builder field:@"firstName" value:@"Bob"];
    [builder field:@"lastName" value:@"Bradley"];
    NSUInteger friendCount = 3;
    [builder field:@"friendCount" value:FGValue(friendCount)];
    [builder field:@"address" assoc:Address.class];
    [builder initWith:@selector(initWithFirstName:lastName:) fieldNames:@[ @"firstName", @"lastName" ]];
    traitDefiners[@"homeless"] = ^(FGDefinitionBuilder *homelessBuilder) {
        [homelessBuilder field:@"address" value:nil];
    };
FGFactoryEnd
