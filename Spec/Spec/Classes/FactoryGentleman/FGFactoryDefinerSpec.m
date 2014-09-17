#import "FGFactoryDefiner.h"

#import "FGFactoryDefinitionRegistry.h"

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
        factoryDefinitionRegistry = mock([FGFactoryDefinitionRegistry class]);
        subject = [[MutableObjectFactoryDefiner alloc] initWithObjectClass:definedClass
                                                 factoryDefinitionRegistry:factoryDefinitionRegistry];
    });

    it(@"base class is abstract", ^{
        expect(^{
            [[[FGFactoryDefiner alloc] init] registerDefinitions];
        }).to.raiseAny();
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
            [subject registerBaseDefinition:baseDefinition
                              traitDefiners:traitDefiners];

            [verify(factoryDefinitionRegistry) registerFactoryDefinition:baseDefinition
                                                                forClass:[NSString class]];
        });

        it(@"registers the trait definitions", ^{
            [subject registerBaseDefinition:baseDefinition
                              traitDefiners:traitDefiners];

            [verify(factoryDefinitionRegistry) registerFactoryDefinition:anything()
                                                                forClass:[NSString class]
                                                                   trait:@"foo"];
        });
    });
SpecEnd
