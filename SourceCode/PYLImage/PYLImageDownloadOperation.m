//
//  PYLImageDownloadOperation.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/20.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLImageDownloadOperation.h"
#import "UIImage+PYL.h"
#import <UIKit/UIKit.h>

@interface PYLImageDownloadOperation ()
@property (nonatomic) NSURL *url;
@property (nonatomic, copy) void(^completion)(UIImage *decompressedImage);
@end

@implementation PYLImageDownloadOperation {
    BOOL _finish;
    BOOL _execute;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (instancetype)initWithURL:(NSURL *)url completion:(void(^)(UIImage *decompressedImage))completion {
    self = [super init];
    self.url = url;
    self.completion = completion;
    return self;
}

- (void)start {
    if ([self isCancelled]) {
        NSLog(@"取消成功 %@", _url);
        [self _setFinish:YES];
        return;
    }
    [self _setExecute:YES];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
}

- (void)main {
    @try {
        if ([self isCancelled]) {
            NSLog(@"取消成功 %@", _url);
            [self _setFinish:YES];
            [self _setExecute:NO];
            return;
        }
//        NSLog(@"thread: %@", [NSThread currentThread]);
        
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:_url options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"download error %@", error);
            [self _setFinish:YES];
            [self _setExecute:NO];
            return;
        }
        
        if ([self isCancelled]) {
            NSLog(@"取消成功 %@", _url);
            [self _setFinish:YES];
            [self _setExecute:NO];
            return;
        }
        
        //解压
        UIImage *image = [[UIImage alloc] initWithData:data];
        image = [image decompress];
        
        if (![self isCancelled]) {
            _completion(image);
        }
        
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
