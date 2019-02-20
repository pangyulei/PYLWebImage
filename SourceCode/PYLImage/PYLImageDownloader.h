//
//  PYLImageDownloader.h
//  PYLTiled
//
//  Created by yulei pang on 2019/2/20.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@interface PYLImageDownloader : NSObject
+ (instancetype)shared;
- (void)downloadImageURL:(NSURL *)url completion:(void(^)(UIImage *decompressedImage))cmpl;
- (void)cancelDownloadImageURL:(NSURL*)url;
@end
