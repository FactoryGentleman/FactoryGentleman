# FactoryGentleman [![Build Status](https://travis-ci.org/soundcloud/FactoryGentleman.svg?branch=master)](https://travis-ci.org/soundcloud/FactoryGentleman)

A simple library to help define model factories for use when testing your iOS/Mac applications. Heavily based on [FactoryGirl](https://github.com/thoughtbot/factory_girl) for Ruby.

## The Problem

We have a test on class `SomeClass` that requires an instance of Data Value Object `User`. The class only makes use of the `username` property.

In the test, we have to generate a valid User object, even though we don't care about almost all of it's properties:

```objective-c
SpecBegin(SomeClass)
    __block SomeClass *subject;

    before(^{
        User *user = [[User alloc] init];
        user.firstName = @"Bill";
        user.lastName = @"Smith";
        user.friendCount = 7;
        user.title = @"Mr";
        user.maidenName = @"Bloggs";
        subject = [[SomeClass alloc] initWithUser:user];
    });

    it(@"is valid", ^{
        expect([subject isValid]).to.beTruthy();
    });
});
```

This setup code begins to dominate even the simplest of tests, and as we start to write more tests requiring `User`s, we end up writing a `ModelFixtures` class to DRY it up a little bit:

```objective-c
SpecBegin(SomeClass)
    __block SomeClass *subject;

    before(^{
        User *user = [ModelFixtures user];
        subject = [[SomeClass alloc] initWithUser:user];
    });

    it(@"is valid", ^{
        expect([subject isValid]).to.beTruthy();
    });
});
```

This is OK for a while, but we realise then that we need multiple sligtly different fixtures for different tests. The ModelFixtures class then ends up littered with extra methods to help like this:

```objective-c
@interface ModelFixtures : NSObject
+ (User *)user;
+ (User *)userWithFirstName:(NSString *)firstName;
+ (User *)userWithFirstName:(NSString *)firstName
                   lastName:(NSString *)lastName;
+ (User *)userWithFirstName:(NSString *)firstName
                   lastName:(NSString *)lastName
                 maidenName:(NSString *)maidenName;
@end
```

## Introducing FactoryGentleman

With FactoryGentleman, you define the object's base fields in one file, and later build the objects, together with any overridden fields you wish.

### Creating a factory

Create an implementation file (*.m) with the factory definition:

```objective-c
#import <FactoryGentleman/FactoryGentleman.h>

#import "User.h"

FGFactoryBegin(User)
    [builder field:@"firstName" value:@"Bob"];
    [builder field:@"lastName" value:@"Bradley"];
    [builder field:@"friendCount" integerValue:10];
    [builder field:@"title" value:@"Mr"];
    [builder field:@"maidenName" value:@"Macallister"];
FGFactoryEnd
```

### Using the factory in your tests

```objective-c
#import <FactoryGentleman/FactoryGentleman.h>

#import "User.h"

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
#import <FactoryGentleman/FactoryGentleman.h>

#import "User.h"

SpecBegin(User)
    __block User *subject;

    context(@"when user has no first name", ^{
        before(^{
            subject = FGBuildWith(User, ^{
                [builder field:@"firstName" value:nil];
            });
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });
    });
});
```

### Complex and Sequential Fields

You can define a field with some more complex state-dependent values using blocks:

```objective-c
#import <FactoryGentleman/FactoryGentleman.h>

#import "User.h"

FGFactoryBegin(User)
    __block int currentId = 0;
    [builder field:@"resourceId" by:^{
        return @(++currentId);
    }];
    [builder field:@"firstName" value:@"Bob"];
    [builder field:@"lastName" value:@"Bradley"];
    [builder field:@"friendCount" integerValue:10];
    [builder field:@"title" value:@"Mr"];
    [builder field:@"maidenName" value:@"Macallister"];
FGFactoryEnd
```

### Immutable Properties

You can define objects with immutable (i.e. readonly) properties via listing initializer selector together with the field names needed:

```objective-c
#import <FactoryGentleman/FactoryGentleman.h>

#import "User.h"

FGFactoryBegin(User)
    [builder field:@"firstName" value:@"Bob"];
    [builder field:@"lastName" value:@"Bradley"];
    [builder field:@"friendCount" integerValue:10];
    [builder field:@"title" value:@"Mr"];
    [builder field:@"maidenName" value:@"Macallister"];
    [builder initWith:@selector(initWithFirstName:lastName:) fieldNames:@[ @"firstName", @"lastName" ]];
FGFactoryEnd
```

### Associative Objects

You can define associative objects (objects that themselves have a factory definition) by giving in the name of the factory required:

```objective-c
#import <FactoryGentleman/FactoryGentleman.h>

#import "User.h"

FGFactoryBegin(User)
    [builder field:@"firstName" value:@"Bob"];
    [builder field:@"lastName" value:@"Bradley"];
    [builder field:@"friendCount" value:@10];
    [builder field:@"title" value:@"Mr"];
    [builder field:@"maidenName" value:@"Macallister"];
    [builder field:@"address" assoc:Address.class];
FGFactoryEnd
```

### Traits

For objects with different traits, you can define them within the base definition:

```objective-c
#import <FactoryGentleman/FactoryGentleman.h>

#import "User.h"

FGFactoryBegin(User)
    [builder field:@"firstName" value:@"Bob"];
    [builder field:@"lastName" value:@"Bradley"];
    [builder field:@"friendCount" value:@10];
    [builder field:@"title" value:@"Mr"];
    [builder field:@"maidenName" value:@"Macallister"];
    [builder field:@"address" assoc:Address.class];

    traitDefiners[@"homeless"] = ^(FGDefinitionBuilder *homelessBuilder) {
        [homelessBuilder field:@"address" value:nil];
    };
FGFactoryEnd
```

These can then be used using the corresponding build macros:

```objective-c
subject = FGBuildTrait(User, homeless);
```
```objective-c
subject = FGBuildTraitWith(User, homeless, ^{
    [builder field:@"firstName" value:@"Brian"];
});
```

as well as the associative definition:

```objective-c
FGAssocFieldTrait(user, User, homeless);
```

### Readonly Properties

You can define values for readonly properties (non-primitive), although this
functionality is not available by default. In order to set them you'll have to
define `FG_ALLOW_READONLY` in your prefix header.

## How to install

Add `pod "FactoryGentleman"` to your Podfile

## Authors

  - [Michael England](https://github.com/michaelengland) @ [SoundCloud](https://github.com/soundcloud)
  - [Slavko Krucaj](https://github.com/SlavkoKrucaj) @ [SoundCloud](https://github.com/soundcloud)
  - [Vincent Garrigues](https://github.com/garriguv) @ [SoundCloud](https://github.com/soundcloud)

## License

FactoryGentleman is available under the MIT license. See the LICENSE file for more info.
