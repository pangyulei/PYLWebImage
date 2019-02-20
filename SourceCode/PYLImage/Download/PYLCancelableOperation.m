//
//  PYLCancelableOperation.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/20.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLCancelableOperation.h"

@implementation PYLCancelableOperation
{
    BOOL _finish;
    BOOL _execute;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (void)start {
    if ([self isCancelled] || !self.executeBlock) {
        NSLog(@"取消成功");
        [self _setFinish:YES];
        return;
    }
    [self _setExecute:YES];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
}

- (void)main {
    @try {
        if ([self isCancelled]) {
            NSLog(@"取消成功");
            [self _setFinish:YES];
            [self _setExecute:NO];
            return;
        }
        
        self.executeBlock(self);
        
        [self _setFinish:YES];
        [self _setExecute:NO];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)_setFinish:(BOOL)finish {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    _finish = finish;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
}

- (void)_setExecute:(BOOL)execute {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    _execute = execute;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
}

- (BOOL)isFinished {
    return _finish;
}

- (BOOL)isExecuting {
    return _execute;
}

@end
