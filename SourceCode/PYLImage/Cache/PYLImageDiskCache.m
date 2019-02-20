//
//  PYLImageDiskCache.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLImageDiskCache.h"
#import <UIKit/UIKit.h>
#import "UIImage+PYL.h"

#define Byte 1
#define KB (1024*Byte)
#define MB (1024*KB)
#define DefaultMaxSize (20 * MB)

@interface PYLImageDiskCache ()
@property(nonatomic,assign) double currentBytes;
//@property(nonatomic) NSMutableArray<NSString*> *lruKeys;//最近使用的都在最后面，0开始的是最近没用的
@end

@implementation PYLImageDiskCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxBytes = DefaultMaxSize;
        _currentBytes = [self countSize];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *dirPath = [self dirPath];
        if (![fm fileExistsAtPath:dirPath]) {
            NSError *e;
            if (![fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&e]) {
                NSAssert(false, [e description]);
            }
        }
    }
    return self;
}

- (double)countSize {
    NSURL *dir = [NSURL URLWithString:[self dirPath]];
    NSArray *resourceKeys = @[NSURLTotalFileAllocatedSizeKey];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:dir includingPropertiesForKeys:resourceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    double size = 0;
    for (NSURL *url in enumerator) {
        NSDictionary *dict = [url resourceValuesForKeys:resourceKeys error:nil];
        size += [dict[NSURLTotalFileAllocatedSizeKey] doubleValue];
    }
    return size;
}

- (void)clear {
    _maxBytes = 0;
    _currentBytes = 0;
//    [_lruKeys removeAllObjects];
}

- (void)deleteUntilBytes:(double)bytes {
    if (bytes <= 0) {
        [self clear];
        return;
    }
    //使用 LRU 算法
    NSURL *dir = [NSURL URLWithString:[self dirPath]];
    NSArray *resourceKeys = @[NSURLTotalFileAllocatedSizeKey,NSURLContentAccessDateKey];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:dir includingPropertiesForKeys:resourceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    NSMutableArray *files = @[].mutableCopy;
    NSString *namekey = @"name";
    for (NSURL *url in enumerator) {
        NSMutableDictionary *dict = [[url resourceValuesForKeys:resourceKeys error:nil] mutableCopy];
        dict[namekey] = url.lastPathComponent;
        [files addObject:dict];
    }
    files = [[files sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* obj1, NSDictionary* obj2) {
        NSDate *date1 = obj1[NSURLContentAccessDateKey];
        NSDate *date2 = obj2[NSURLContentAccessDateKey];
        if ([date2 timeIntervalSinceDate:date1] >= 0) {
            //obj2 比 obj1 更晚访问, obj2 应该排在后面
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }] mutableCopy];
    for (NSDictionary *dict in files) {
        unsigned long long size = [dict[NSURLTotalFileAllocatedSizeKey] unsignedLongLongValue];
        _currentBytes -= size;
        NSString *key = dict[namekey];
        NSString *filepath = [[self dirPath] stringByAppendingPathComponent:key];
        NSError *error;
        NSAssert([[NSFileManager defaultManager] removeItemAtPath:filepath error:&error], [error description]);
    }
}

- (void)setMaxBytes:(double)maxBytes {
    _maxBytes = maxBytes;
    [self deleteUntilBytes:maxBytes];
}

- (void)saveImage:(UIImage *)image forKey:(NSString *)key {
    if (image.pyl_bytes+_currentBytes>_maxBytes) {
        //腾出足够空间
        [self deleteUntilBytes:_maxBytes-image.pyl_bytes];
    }
    NSString *filepath = [[self dirPath] stringByAppendingPathComponent:key];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filepath]) {
        [fm removeItemAtPath:filepath error:nil];
    }
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSError *error;
    NSAssert([data writeToFile:filepath options:NSDataWritingAtomic error:&error], error.localizedDescription);
    _currentBytes += image.pyl_bytes;
//    [_lruKeys removeObject:key];
//    [_lruKeys addObject:key];
}

- (UIImage *)fetchImageForKey:(NSString *)key {
    NSString *filepath = [[self dirPath] stringByAppendingPathComponent:key];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    UIImage *image = [UIImage imageWithData:data];
//    [_lruKeys removeObject:key];
//    [_lruKeys addObject:key];
    return image;
}

- (NSString*)dirPath {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [documentPath stringByAppendingPathComponent:@"PYLImageDiskCache/Default"];
}

@end
