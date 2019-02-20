//
//  PYLImageDownloader.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/20.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLImageDownloader.h"
#import "PYLImageDownloadOperation.h"
#import "PYLImageCache.h"
#import "NSURL+MD5.h"

@interface PYLImageDownloader () <NSMutableCopying, NSCopying>
@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic) NSMapTable<NSString*,PYLImageDownloadOperation*>*urlOperationMap;
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
        d.urlOperationMap = [NSMapTable strongToWeakObjectsMapTable];
        d.concurrentQueue = dispatch_queue_create("q", DISPATCH_QUEUE_CONCURRENT);
    });
    return d;
}

- (void)downloadImageURL:(NSURL *)url completion:(UIImage*(^)(UIImage *,BOOL fromCache))cmpl {
    if (!url.absoluteString.length || !cmpl) {
        return;
    }
    
    __weak typeof(PYLImageDownloader) *weakself = self;
    dispatch_barrier_async(_concurrentQueue, ^{
        //缓存有的就别下了
        if ([[PYLImageCache shared] existImageForKey:url.MD5]) {
            UIImage *cacheImage = [[PYLImageCache shared] fetchImageForKey:url.MD5];
            cmpl(cacheImage, YES);
            return;
        }
        
        //已经入队的就别下了
        __strong typeof(PYLImageDownloader) *strongself = weakself;
        if ([strongself.urlOperationMap objectForKey:url.MD5]) {
            return;
        }
        /*
         使用 operation queue 是线程安全的
         https://developer.apple.com/documentation/foundation/nsoperationqueue
         这里是为了给 urlOperationMap 上锁
         */
        
        PYLImageDownloadOperation *operation = [[PYLImageDownloadOperation alloc] initWithURL:url completion:^(UIImage *decompressedImage) {
            UIImage *imageToCache = cmpl(decompressedImage, NO);
            if (imageToCache) {
                [[PYLImageCache shared] saveImage:imageToCache forKey:url.MD5];
            } else {
                [[PYLImageCache shared] saveImage:decompressedImage forKey:url.MD5];
            }
        }];
        [strongself.queue addOperation:operation];
        [strongself.urlOperationMap setObject:operation forKey:url.MD5];
    });
}

- (void)cancelDownloadImageURL:(NSURL*)url {
    __block PYLImageDownloadOperation *operation;
    dispatch_sync(_concurrentQueue, ^{
        operation = [self.urlOperationMap objectForKey:url.MD5];
    });
    [operation cancel];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self.class allocWithZone:zone];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self.class allocWithZone:zone];
}

@end
