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
- (void)saveImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)fetchImageForKey:(NSString *)key;
@end
