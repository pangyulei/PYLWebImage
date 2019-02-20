//
//  PYLImageDiskCache.h
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@interface PYLImageDiskCache : NSObject
@property(nonatomic,assign) double maxBytes; //默认 50mb
- (void)clear;
- (void)deleteUntilBytes:(double)bytes;
- (void)saveImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)fetchImageForKey:(NSString *)key;
@end
