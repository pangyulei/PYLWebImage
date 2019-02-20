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
#define KB (1024*Byte)
#define MB (1024*KB)
#define DefaultMaxSize (1 * MB)

@interface PYLImageMemoryCache ()
@property(nonatomic) NSCache *cache;
@property(nonatomic,assign) double currentBytes;
@property(nonatomic) NSMutableArray<NSString*> *lruKeys;//最近使用的都在最后面，0开始的是最近没用的
@property(nonatomic) NSMapTable<NSString*,UIImage*> *weakCache;
@end
@implementation PYLImageMemoryCache

- (void)saveImage:(UIImage *)image forKey:(NSString *)key {
    if (!image || !key.length) {
        return;
    }
    if (image.pyl_bytes + _currentBytes > _maxBytes) {
        NSLog(@"超了图片保存到内存失败 max:%.2f cur:%.2f, img:%.2f", _maxBytes, _currentBytes, image.pyl_bytes);
        //腾出足够空间
        [self deleteUntilBytes:_maxBytes-image.pyl_bytes];
    }
    NSLog(@"成功保存到内存 %@", key);
    [_cache setObject:image forKey:key];
    _currentBytes += image.pyl_bytes;
    [_lruKeys removeObject:key];
    [_lruKeys addObject:key];
}

- (UIImage *)fetchImageForKey:(NSString *)key {
    //更新 lru
    [_lruKeys removeObject:key];
    [_lruKeys addObject:key];
    UIImage *image = [_cache objectForKey:key];
    if (!image) {
        //cache 里没有，尝试weakcache里有没有
        image = [_weakCache objectForKey:key];
        if (image) {
            //恢复到 _cache 里
            [self saveImage:image forKey:key];
        }
    }
    return image;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxBytes = DefaultMaxSize;
        _cache = [NSCache new];
        _currentBytes = 0;
        _lruKeys = @[].mutableCopy;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarnning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        _weakCache = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)memoryWarnning {
    [self clear];
}

- (void)clear {
    _maxBytes = 0;
    _currentBytes = 0;
    [_cache removeAllObjects];
    [_lruKeys removeAllObjects];
}

- (void)deleteUntilBytes:(double)bytes {
    if (bytes <= 0) {
        [self clear];
        return;
    }
    //使用 LRU 算法
    NSMutableArray *keysToDelete = @[].mutableCopy;
    for (int i=0;i<_lruKeys.count && _currentBytes>bytes;i++) {
        NSString *key = _lruKeys[i];
        UIImage *image = [_cache objectForKey:key];
        _currentBytes -= image.pyl_bytes;
        [keysToDelete addObject:key];
        [_cache removeObjectForKey:key];
    }
    [_lruKeys removeObjectsInArray:keysToDelete];
}

- (void)setMaxBytes:(double)maxBytes {
    _maxBytes = maxBytes;
    [self deleteUntilBytes:maxBytes];
}

@end
