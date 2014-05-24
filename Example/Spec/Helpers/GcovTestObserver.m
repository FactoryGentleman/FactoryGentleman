#import "GcovTestObserver.h"

@implementation GcovTestObserver

- (void)stopObserving
{
    [super stopObserving];
    extern void __gcov_flush(void);
    __gcov_flush();
}

@end
