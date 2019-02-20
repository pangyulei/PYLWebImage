//
//  PYLImageDownloader.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/20.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLImageDownloader.h"
#import "PYLImageDownloadOperation.h"

@interface PYLImageDownloader () <NSMutableCopying, NSCopying>
@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic) NSMutableDictionary<NSString*,PYLImageDownloadOperation*>*urlOperationMap;
@property (nonatomic) dispatch_queue_t concurrentQueue;
@end

@implementation PYLImageDownloader

+ (instancetype)shared {
    return [self new];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    static PYLImageDownloader *d;
    dispatch_once(&onceToken, ^{
        d = [super allocWithZone:zone];
        d.queue = [NSOperationQueue new];
        d.queue.maxConcurrentOperationCount = 10;
        d.urlOperationMap = @{}.mutableCopy;
        d.concurrentQueue = dispatch_queue_create("q", DISPATCH_QUEUE_CONCURRENT);
    });
    return d;
}

- (void)downloadImageURL:(NSURL *)url completion:(void (^)(UIImage *))cmpl {
    if (!url.absoluteString.length || !cmpl) {
        return;
    }
    __weak typeof(PYLImageDownloader) *weakself = self;
    dispatch_barrier_async(_concurrentQueue, ^{
        __strong typeof(PYLImageDownloader) *strongself = weakself;
        /*
         使用 operation queue 是线程安全的
         https://developer.apple.com/documentation/foundation/nsoperationqueue
         这里是为了给 urlOperationMap 上锁
         */
        
        PYLImageDownloadOperation *operation = [[PYLImageDownloadOperation alloc] initWithURL:url completion:^(UIImage *decompressedImage) {
            strongself.urlOperationMap[url.absoluteString] = nil;
            cmpl(decompressedImage);
        }];
        [self.queue addOperation:operation];
        self.urlOperationMap[url.absoluteString] = operation;
    });
}

- (void)cancelDownloadImageURL:(NSURL*)url {
    __block PYLImageDownloadOperation *operation;
    dispatch_sync(_concurrentQueue, ^{
        operation = self.urlOperationMap[url.absoluteString];
    });
    [operation cancel];
    dispatch_barrier_async(_concurrentQueue, ^{
        self.urlOperationMap[url.absoluteString] = nil;
    });
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self.class allocWithZone:zone];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self.class allocWithZone:zone];
}

@end
