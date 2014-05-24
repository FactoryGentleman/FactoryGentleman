#import <FactoryGentleman/FGFactoryDefinitionRegistry.h>

@interface FGFactoryDefiner (Spec)
- (instancetype)initWithObjectClass:(Class)objectClass
          factoryDefinitionRegistry:(FGFactoryDefinitionRegistry *)factoryDefinitionRegistry;
@end

@interface MutableObjectFactoryDefiner : FGFactoryDefiner
@property (nonatomic) BOOL hasRegistered;
@end

@implementation MutableObjectFactoryDefiner

- (instancetype)initWithFactoryDefinitionRegistry:(FGFactoryDefinitionRegistry *)factoryDefinitionRegistry
{
    self = [super initWithObjectClass:[NSString class]
            factoryDefinitionRegistry:factoryDefinitionRegistry];
    if (self) {
        _hasRegistered = NO;
    }
    return self;
}

- (void)registerDefinitions
{
    self.hasRegistered = YES;
}

@end

SpecBegin(FGFactoryDefiner)
    __block MutableObjectFactoryDefiner *subject;
    __block Class definedClass;
    __block id factoryDefinitionRegistry;

    before(^{
        definedClass = [NSString class];
        factoryDefinitionRegistry = [OCMockObject niceMockForClass:[FGFactoryDefinitionRegistry class]];
        subject = [[MutableObjectFactoryDefiner alloc] initWithObjectClass:definedClass
                                                 factoryDefinitionRegistry:factoryDefinitionRegistry];
    });

    context(@"when mutable factory is defined", ^{
        it(@"registers a factory definition with field definitions given", ^{
            [subject registerDefinitions];

            expect(subject.hasRegistered).to.beTruthy();
        });
    });

    describe(@"-registerBaseDefinition:traitDefiners:", ^{
        __block FGFactoryDefinition *baseDefinition;
        __block NSDictionary *traitDefiners;

        before(^{
            baseDefinition = [[FGFactoryDefinition alloc] initWithConstructor:nil
                                                        initializerDefinition:nil
                                                             fieldDefinitions:@{}];

            traitDefiners = @{ @"foo" : ^(FGDefinitionBuilder *builder) {} };
        });

        it(@"registers the base definition", ^{
            [[factoryDefinitionRegistry expect] registerFactoryDefinition:baseDefinition
                                                                 forClass:[NSString class]];

            [subject registerBaseDefinition:baseDefinition
                              traitDefiners:traitDefiners];

            [factoryDefinitionRegistry verify];
        });

        it(@"registers the trait definitions", ^{
            [[factoryDefinitionRegistry expect] registerFactoryDefinition:OCMOCK_ANY
                                                                 forClass:[NSString class]
                                                                    trait:@"foo"];

            [subject registerBaseDefinition:baseDefinition
                              traitDefiners:traitDefiners];

            [factoryDefinitionRegistry verify];
        });
    });
SpecEnd
