//
//  PYLImageDiskCache.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLImageDiskCache.h"
#import <UIKit/UIKit.h>

#define Byte 1
#define MB (1024*Byte)
#define DefaultMaxSize (50 * MB)
@implementation PYLImageDiskCache

- (instancetype)init {
    self = [super init];
    _maxBytes = DefaultMaxSize;
    return self;
}

- (void)clear {
    _maxBytes = 0;
    //pang todo 应该直接删除文件夹
    [self clearUntilBytes:0];
}

- (void)clearUntilBytes:(double)newMaxBytes {
    //pang todo 应该使用 LRU 算法
    _maxBytes = newMaxBytes;
}

- (void)setMaxBytes:(double)maxBytes {
    if (maxBytes <= 0) {
        [self clear];
    } else {
        [self clearUntilBytes:maxBytes];
    }
}

- (void)saveImage:(UIImage *)image forKey:(NSString *)key {
    
}

@end
