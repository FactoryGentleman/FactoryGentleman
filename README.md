# FactoryGentleman

A simple library to help define model factories for use when testing your iOS/Mac applications.

## Simple usage

### Creating a factory

```objective-c
#import "FactoryDefiner.h"

FactoryBegin(User)
    field(@"firstName", @"Bob")
    field(@"lastName", @"Bradley")
FactoryEnd
```

### Using the factory in your tests

```objective-c
#import "FactoryGentleman.h"

SpecBegin(User)
    __block User *subject;

    before(^{
        subject = FGBuild(User);
    });

    it(@"is valid", ^{
        expect([subject isValid]).to.beTruthy();
    });
});
```

### Overriding fields

```objective-c
#import "FactoryGentleman.h"

SpecBegin(User)
    __block User *subject;

    before(^{
        subject = FGBuildWith(User, field(@"firstName", nil));
    });

    it(@"is NOT valid", ^{
        expect([subject isValid]).to.beFalsy();
    });
});
```

## How to install

Add `pod "OHAttributedLabel"` to your Podfile

## Authors

[Michael England](http://github.com/michaelengland) @ [SoundCloud](http://github.com/soundcloud)

## License

FactoryGentleman is available under the MIT license. See the LICENSE file for more info.
