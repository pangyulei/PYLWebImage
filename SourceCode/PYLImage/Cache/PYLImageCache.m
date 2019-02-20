//
//  PYLImageCache.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLImageCache.h"
#import "PYLImageMemoryCache.h"
#import "PYLImageDiskCache.h"

@interface PYLImageCache () <NSMutableCopying, NSCopying>
@property (nonatomic) PYLImageMemoryCache *mem;
@property (nonatomic) PYLImageDiskCache *disk;
@property (nonatomic) dispatch_queue_t queue;
@end

@implementation PYLImageCache

+ (PYLImageCache *)shared {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    static PYLImageCache *cache;
    dispatch_once(&onceToken, ^{
        cache = [super allocWithZone:zone];
        cache.mem = [PYLImageMemoryCache new];
        cache.disk = [PYLImageDiskCache new];
        cache.queue = dispatch_queue_create("PYLImageCacheQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return cache;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [self.class allocWithZone:zone];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [self.class allocWithZone:zone];
}

#pragma mark - PYLImageCacheProtocol
- (void)saveImage:(UIImage *)image forKey:(NSString *)key {
    if (!image || !key.length) {
        return;
    }
    dispatch_barrier_async(_queue, ^{
        //先存内存
        [self.mem saveImage:image forKey:key];
        [self.disk saveImage:image forKey:key];
    });
}

- (UIImage *)fetchImageForKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    __block UIImage *image;
    dispatch_sync(_queue, ^{
        image = [self.mem fetchImageForKey:key];
        if (image) {
            NSLog(@"从内存读取图片成功 %@", key);
        } else {
            image = [self.disk fetchImageForKey:key];
            if (image) {
                NSLog(@"从硬盘读取图片成功 %@", key);
                [self.mem saveImage:image forKey:key];
            }
        }
    });
    return image;
}

- (BOOL)existImageForKey:(NSString *)key {
    if ([_mem existImageForKey:key]) {
        return YES;
    }
    return [_disk existImageForKey:key];
}

@end
