//
//  CardCellLayer.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/21.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "CardCellLayer.h"
#import <UIKit/UIKit.h>
#import "CardCellDrawOperation.h"

static NSOperationQueue *q;

@interface CardCellLayer ()
@property (nonatomic) CardCellDrawOperation *p;
@end

@implementation CardCellLayer

- (void)setNeedsDisplay {
    if (_p) {
        [_p cancel];
    }
    [super setNeedsDisplay];
}

- (void)display {
    [super display];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        q = [NSOperationQueue new];
        q.maxConcurrentOperationCount = 20;
    });
    CGRect r = self.bounds;
    _p = [CardCellDrawOperation new];
    [_p setExecuteBlock:^(PYLCancelableOperation *operation) {
        UIGraphicsBeginImageContext(r.size);
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSaveGState(c);
        CGContextSetFillColorWithColor(c, [UIColor.blueColor colorWithAlphaComponent:0.5].CGColor);
        CGContextAddRect(c, r);
        CGContextFillPath(c);
        if ([operation isCancelled]) {
            CGContextRestoreGState(c);
            UIGraphicsEndImageContext();
            NSLog(@"取消 draw");
            return;
        }
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        CGContextRestoreGState(c);
        UIGraphicsEndImageContext();
        if ([operation isCancelled]) {
            NSLog(@"取消 draw");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![operation isCancelled]) {
                [self.delegate performSelector:@selector(asyncDraw:) withObject:image];
            } else {
                NSLog(@"取消 draw");
            }
        });
    }];
    [q addOperation:_p];
}

@end
