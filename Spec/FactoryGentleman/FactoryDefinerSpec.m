#import "FactoryDefiner.h"

#import "FactoryDefinitionRegistry.h"

@interface FactoryDefiner (Spec)
- (instancetype)initWithObjectClass:(Class)objectClass
          factoryDefinitionRegistry:(FactoryDefinitionRegistry *)factoryDefinitionRegistry;
- (void)registerDefinitions;
@end

@interface MutableObjectFactoryDefiner : FactoryDefiner

@end

@implementation MutableObjectFactoryDefiner

- (void)defineFieldDefinitions:(NSMutableDictionary *)fieldDefinitions
{
    [fieldDefinitions setObject:@12345 forKey:@"someField"];
}

@end

SpecBegin(FactoryDefiner)
    __block FactoryDefiner *subject;
    __block Class definedClass;
    __block id factoryDefinitionRegistry;

    before(^{
        definedClass = NSString.class;
        factoryDefinitionRegistry = [OCMockObject mockForClass:FactoryDefinitionRegistry.class];
        subject = [[MutableObjectFactoryDefiner alloc] initWithObjectClass:definedClass
                                                 factoryDefinitionRegistry:factoryDefinitionRegistry];
    });

    context(@"when mutable factory is defined", ^{
        it(@"registers a factory definition with field definitions given", ^{
            id factoryDefinitionArg = [OCMArg checkWithBlock:^BOOL(FactoryDefinition *definition) {
                return [@12345 isEqual:definition.fieldDefinitions[@"someField"]];
            }];
            [[factoryDefinitionRegistry expect] registerFactoryDefinition:factoryDefinitionArg forClass:definedClass];

            [subject registerDefinitions];

            [factoryDefinitionRegistry verify];
        });
    });
SpecEnd
