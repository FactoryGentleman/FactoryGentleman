#import "FGFieldDefinition.h"

SpecBegin(FGFieldDefinitionSpec)
    __block FGFieldDefinition *subject;
    __block id (^definition)();
    before(^{
        definition = ^id{ return nil; };
        subject = [FGFieldDefinition withFieldName:@"fieldDefinition" definition:definition];
    });

    describe(@"instantiate", ^{
        context(@"when fieldName missing", ^{
            it(@"should raise assertion", ^{
                expect(^{
                    [FGFieldDefinition withFieldName:nil definition:^id {
                        return nil;
                    }];
                }).to.raise(@"NSInternalInconsistencyException");
            });
        });

        context(@"when fieldName missing", ^{
            it(@"should raise assertion", ^{
                expect(^{
                    [FGFieldDefinition withFieldName:@"fieldDefinition" definition:nil];
                }).to.raise(@"NSInternalInconsistencyException");
            });
        });
    });

    describe(@"equality", ^{
        __block FGFieldDefinition *otherFieldDefinition;

        context(@"when field names equal", ^{
            before(^{
                otherFieldDefinition = [FGFieldDefinition withFieldName:@"fieldDefinition"
                                                             definition:^{
                                                                 return @"abc";
                                                             }];
            });

            it(@"should be equal", ^{
                expect(subject).to.equal(otherFieldDefinition);
            });
        });

        context(@"when field names different", ^{
            context(@"when block not equal", ^{
                before(^{
                    otherFieldDefinition = [FGFieldDefinition withFieldName:@"notEqual"
                                                                 definition:^{
                                                                     return @"abc";
                                                                 }];
                });

                it(@"should not be equal", ^{
                    expect(subject).toNot.equal(otherFieldDefinition);
                });
            });

            context(@"and blocks equal", ^{
                before(^{
                    otherFieldDefinition = [FGFieldDefinition withFieldName:@"notEqual"
                                                                 definition:definition];
                });
                
                it(@"should not be equal", ^{
                    expect(subject).toNot.equal(otherFieldDefinition);
                });
            });
        });
    });
SpecEnd
