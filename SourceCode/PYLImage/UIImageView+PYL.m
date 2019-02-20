
//
//  UIImageView+PYL.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "UIImageView+PYL.h"
#import "PYLImageCache.h"
#import "PYLImageDownloader.h"

@implementation UIImageView (PYL)

- (void)pyl_setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder {
    //pang todo 优化图片加载
    UIImage *image = [[PYLImageCache shared] fetchImageForKey:url.absoluteString];
    if (image) {
        self.image = image;
        return;
    }
    self.image = nil;
    [[PYLImageDownloader shared] downloadImageURL:url completion:^(UIImage *decompressedImage) {
        if (decompressedImage) {
            [[PYLImageCache shared] saveImage:decompressedImage forKey:url.absoluteString];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = decompressedImage;
            });
        }
    }];
}

@end
