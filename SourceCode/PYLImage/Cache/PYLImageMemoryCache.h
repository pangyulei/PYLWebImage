//
//  PYLImageMemoryCache.h
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@interface PYLImageMemoryCache : NSObject
- (void)saveImage:(UIImage *)image forKey:(NSString *)key;
- (void)clear;
- (UIImage *)fetchImageForKey:(NSString *)key;
@end
