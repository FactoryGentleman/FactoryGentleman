# FactoryGentleman

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
        user.friendCount = @7;
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
#import "FactoryDefiner.h"

FactoryBegin(User)
    field(firstName, @"Bob")
    field(lastName, @"Bradley")
    field(friendCount, @10)
    field(title, @"Mr")
    field(maidenName, @"Macallister")
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

    context(@"when user has no first name", ^{
        before(^{
            subject = FGBuildWith(User, field(firstName, nil););
        });

        it(@"is NOT valid", ^{
            expect([subject isValid]).to.beFalsy();
        });
    });
});
```

### Immutable Properties

You can define objects with immutable (i.e. readonly) properties via listing initializer selector together with the field names needed:

```objective-c
FactoryBegin(User)
    field(firstName, @"Bob")
    field(lastName, @"Bradley")
    field(friendCount, @10)
    field(title, @"Mr")
    field(maidenName, @"Macallister")
    initWith(initWithFirstName:lastName:, f(firstName), f(lastName))
FactoryEnd
```

### Associative Objects

You can define associative objects (objects that themselves have a factory definition) by giving in the name of the factory required:

```objective-c
FactoryBegin(User)
    field(firstName, @"Bob")
    field(lastName, @"Bradley")
    field(friendCount, @10)
    field(title, @"Mr")
    field(maidenName, @"Macallister")
    assocField(address, Address)
FactoryEnd
```

## How to install

Add `pod "OHAttributedLabel"` to your Podfile

## Authors

[Michael England](https://github.com/michaelengland) @ [SoundCloud](https://github.com/soundcloud)

## License

FactoryGentleman is available under the MIT license. See the LICENSE file for more info.
