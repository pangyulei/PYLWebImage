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

@interface PYLImageMemoryCache ()
@property(nonatomic) NSCache *cache;
@property(nonatomic) NSMapTable<NSString*,UIImage*> *weakCache;
@end
@implementation PYLImageMemoryCache

- (void)saveImage:(UIImage *)image forKey:(NSString *)key {
    if (!image || !key.length) {
        return;
    }
    [_cache setObject:image forKey:key];
}

- (UIImage *)fetchImageForKey:(NSString *)key {
    //更新 lru
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
        _cache = [NSCache new];
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
    [_cache removeAllObjects];
}

@end
