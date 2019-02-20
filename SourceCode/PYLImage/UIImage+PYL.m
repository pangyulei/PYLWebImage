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

- (double)pyl_bytes {
    NSNumber *bytes = objc_getAssociatedObject(self, _cmd);
    if (!bytes) {
        NSData *data = UIImageJPEGRepresentation(self, 1);
        bytes = @(data.length);
        objc_setAssociatedObject(self, _cmd, bytes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return bytes.doubleValue;
}

- (UIImage *)decompress {
    //解压
    UIGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointZero];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
