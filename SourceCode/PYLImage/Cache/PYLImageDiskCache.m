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
#define DefaultMaxSize (10 * MB)

@interface PYLImageDiskCache ()
@end

@implementation PYLImageDiskCache

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDirifNeed];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)createDirifNeed {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dirPath = [self dirPath];
    if (![fm fileExistsAtPath:dirPath]) {
        NSError *e;
        NSAssert([fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&e], [e description]);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willTerminate {
    [self deleteUntilBytes:DefaultMaxSize];
}

- (void)deleteUntilBytes:(double)bytes {
    //使用 LRU 算法
    NSURL *dir = [NSURL URLWithString:[self dirPath]];
    NSArray *resourceKeys = @[NSURLTotalFileAllocatedSizeKey,NSURLContentAccessDateKey];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:dir includingPropertiesForKeys:resourceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    NSMutableArray *files = @[].mutableCopy;
    NSString *namekey = @"name";
    double currentBytes = 0;
    for (NSURL *url in enumerator) {
        NSMutableDictionary *dict = [[url resourceValuesForKeys:resourceKeys error:nil] mutableCopy];
        dict[namekey] = url.lastPathComponent;
        currentBytes += [dict[NSURLTotalFileAllocatedSizeKey] doubleValue];
        [files addObject:dict];
    }
    if (currentBytes<bytes) {
        return;
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
        if (currentBytes < bytes) {
            break;
        }
        NSString *key = dict[namekey];
        NSString *filepath = [[self dirPath] stringByAppendingPathComponent:key];
        NSError *error;
        NSAssert([[NSFileManager defaultManager] removeItemAtPath:filepath error:&error], [error description]);
        currentBytes -= [dict[NSURLTotalFileAllocatedSizeKey] doubleValue];
    }
}

- (void)saveImage:(UIImage *)image forKey:(NSString *)key {
    NSString *filepath = [[self dirPath] stringByAppendingPathComponent:key];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filepath]) {
        [fm removeItemAtPath:filepath error:nil];
    }
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSError *error;
    NSAssert([data writeToFile:filepath options:NSDataWritingAtomic error:&error], error.localizedDescription);
}

- (UIImage *)fetchImageForKey:(NSString *)key {
    NSString *filepath = [[self dirPath] stringByAppendingPathComponent:key];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    UIImage *image = [UIImage imageWithData:data];
    return image.decompress;
}

- (NSString*)dirPath {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [documentPath stringByAppendingPathComponent:@"PYLImageDiskCache/Default"];
}

- (BOOL)existImageForKey:(NSString *)key {
    NSString *filepath = [[self dirPath] stringByAppendingPathComponent:key];
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

@end
