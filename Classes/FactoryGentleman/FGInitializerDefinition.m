#import "FGInitializerDefinition.h"

@implementation FGInitializerDefinition

- (instancetype)initWithSelector:(SEL)selector
                      fieldNames:(NSOrderedSet *)fieldNames
{
    self = [super init];
    if (self) {
        _selector = selector;
        _fieldNames = fieldNames;
    }
    return self;
}

+ (instancetype)definitionWithSelector:(SEL)selector, ...
{
    va_list args;
    va_start(args, selector);
    NSMutableOrderedSet *fieldNames = [[NSMutableOrderedSet alloc] init];
    for (int i = 0; i < [self numberOfArgsForSelector:selector]; i++) {
        [fieldNames addObject:va_arg(args, NSString *)];
    }
    va_end(args);
    return [[self alloc] initWithSelector:selector
                               fieldNames:fieldNames];
}

+ (NSUInteger)numberOfArgsForSelector:(SEL)selector
{
    NSString *selectorString = NSStringFromSelector(selector);
    return [selectorString componentsSeparatedByString:@":"].count - 1;
}

@end
