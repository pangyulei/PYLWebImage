//
//  PYLImageMemoryCache.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLImageMemoryCache.h"
#import <UIKit/UIKit.h>
#import "UIImage+PYL.h"

#define Byte 1
#define MB (1024*Byte)
#define DefaultMaxSize (50 * MB)

@interface PYLImageMemoryCache ()
@property(nonatomic) NSCache *cache;
@property(nonatomic,assign) double currentBytes;
@end
@implementation PYLImageMemoryCache

- (void)saveImage:(UIImage *)image forKey:(NSString *)key {
    if (!image || !key.length) {
        return;
    }
    if (image.pyl_bytes + _currentBytes > _maxBytes) {
        NSLog(@"图片保存到内存失败，因为超了 %@", key);
        //pang todo 删除内存中的东西
        return;
    }
    NSLog(@"成功保存到内存 %@", key);
    [_cache setObject:image forKey:key];
    _currentBytes += image.pyl_bytes;
}

- (UIImage *)fetchImageForKey:(NSString *)key {
    return [_cache objectForKey:key];
}

- (instancetype)init {
    self = [super init];
    _maxBytes = DefaultMaxSize;
    _cache = [NSCache new];
    _currentBytes = 0;
    return self;
}

- (void)clear {
    _maxBytes = 0;
    _currentBytes = 0;
    //pang todo 应该直接删除文件夹
}

- (void)clearUntilBytes:(double)newMaxBytes {
    _maxBytes = newMaxBytes;
    if (_currentBytes > newMaxBytes) {
        //pang todo 应该使用 LRU 算法
        //更新 currentBytes
    }
}

- (void)setMaxBytes:(double)maxBytes {
    if (maxBytes <= 0) {
        [self clear];
    } else {
        [self clearUntilBytes:maxBytes];
    }
}

@end
