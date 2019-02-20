//
//  UIImage+PYL.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "UIImage+PYL.h"
#import <objc/runtime.h>

@implementation UIImage (PYL)

- (UIImage *)decompress {
    //解压
    UIGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
