
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

- (void)pyl_setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder {
    if (!url.absoluteString.length) {
        return;
    }
    
    char *key = "last_url";
    NSString *lastURL = objc_getAssociatedObject(self, key);
    if (lastURL.length && ![lastURL isEqualToString:url.absoluteString]) {
        [[PYLImageDownloader shared] cancelDownloadImageURL:[NSURL URLWithString:lastURL]];
    }
    objc_setAssociatedObject(self, key, url.absoluteString, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    self.image = nil;
    [[PYLImageDownloader shared] downloadImageURL:url completion:^(UIImage *decompressedImage) {
        if (decompressedImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = decompressedImage;
            });
        }
    }];
}

@end
