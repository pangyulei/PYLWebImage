//
//  PYLImageCache.h
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@interface PYLImageCache : NSObject
+ (PYLImageCache *)shared;
- (void)saveImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)fetchImageForKey:(NSString *)key;
@end
