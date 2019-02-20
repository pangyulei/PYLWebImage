//
//  NSURL+MD5.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/20.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "NSURL+MD5.h"
#import "NSString+MD5.h"

@implementation NSURL (MD5)
- (NSString *)MD5 {
    return self.absoluteString.MD5;
}
@end
