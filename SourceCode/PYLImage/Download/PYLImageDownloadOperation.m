//
//  PYLImageDownloadOperation.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/20.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLImageDownloadOperation.h"
#import "UIImage+PYL.h"
#import <UIKit/UIKit.h>

@interface PYLImageDownloadOperation ()
@end

@implementation PYLImageDownloadOperation 

- (instancetype)initWithURL:(NSURL *)url completion:(void(^)(UIImage *decompressedImage))completion {
    self = [super init];
    __weak typeof(self) weakself = self;
    self.executeBlock = ^void(PYLCancelableOperation *operation) {
        __strong typeof(self) strongself = weakself;
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"%@", error.description);
            return;
        }
        if ([strongself isCancelled]) {
            NSLog(@"取消成功");
            return;
        }
        //解压
        UIImage *image = [[UIImage alloc] initWithData:data];
        image = [image decompress];
        
        if (![strongself isCancelled]) {
            completion(image);
        } else {
            NSLog(@"取消成功");
        }
    };
    return self;
}

@end
