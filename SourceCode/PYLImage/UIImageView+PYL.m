
//
//  UIImageView+PYL.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "UIImageView+PYL.h"
#import "PYLImageDownloader.h"
#import <objc/runtime.h>

@implementation UIImageView (PYL)

- (void)pyl_setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder completion:(UIImage*(^)(UIImage *image,BOOL fromCache))completion {
    if (!url.absoluteString.length || !completion) {
        return;
    }
    
    //快速滑动，取消之前未完成的下载
    NSURL *lastImageURL = [self pyl_lastImageURL];
    if (lastImageURL && ![lastImageURL.absoluteString isEqualToString:url.absoluteString]) {
        [[PYLImageDownloader shared] cancelDownloadImageURL:lastImageURL];
    }
    [self setPyl_lastImageURL:url];
    self.image = placeholder;
    [[PYLImageDownloader shared] downloadImageURL:url completion:^UIImage *(UIImage *decompressedImage, BOOL fromCache) {
        return completion(decompressedImage,fromCache);
    }];
}

- (NSURL *)pyl_lastImageURL {
    NSString *a = objc_getAssociatedObject(self, _cmd);
    if (a.length) {
        return [NSURL URLWithString:a];
    } else {
        return nil;
    }
}

- (void)setPyl_lastImageURL:(NSURL*)url {
    objc_setAssociatedObject(self, @selector(pyl_lastImageURL), url.absoluteString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
