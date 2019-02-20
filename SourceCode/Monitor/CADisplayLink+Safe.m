//
//  CADisplayLink+Safe.m
//  PYLFPSLabel
//
//  Created by yulei pang on 2019/2/18.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "CADisplayLink+Safe.h"

@interface SomeObj: NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL sel;
@end

@implementation SomeObj

- (void)fire:(CADisplayLink *)link {
    if (_target && [_target respondsToSelector:_sel]) {
        [_target performSelector:_sel withObject:link];
    } else {
        [link invalidate];
        printf("stop");
    }
}

@end

@implementation CADisplayLink (Safe)

+ (CADisplayLink *)pyl_displayLinkWithTarget:(id)target selector:(SEL)sel {
    SomeObj *middle = [SomeObj new];
    middle.target = target;
    middle.sel = sel;
    return [CADisplayLink displayLinkWithTarget:middle selector:@selector(fire:)];
}

@end
