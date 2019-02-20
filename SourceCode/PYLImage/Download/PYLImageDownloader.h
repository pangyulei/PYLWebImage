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
//如果  completion 返回图，就缓存返回的图，否则缓存解压的图
- (void)downloadImageURL:(NSURL *)url completion:(UIImage*(^)(UIImage *decompressedImage, BOOL fromCache))cmpl;
- (void)cancelDownloadImageURL:(NSURL*)url;
@end
