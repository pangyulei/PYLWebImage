//
//  PYLFPSLabel.m
//  PYLFPSLabel
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "PYLFPSLabel.h"
#import "CADisplayLink+Safe.h"

@interface PYLFPSLabel ()
@property (nonatomic, assign) CFTimeInterval last;
@property (nonatomic, assign) double frames;
@end

@implementation PYLFPSLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    CADisplayLink *link = [CADisplayLink pyl_displayLinkWithTarget:self selector:@selector(frame:)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)frame:(CADisplayLink *)link {
    if (0 == _last) {
        _last = link.timestamp;
        return;
    }
    _frames++;
    double delta = link.timestamp - _last;
    if (delta > 1) {
        double fps = _frames / delta;
        _frames = 0;
        _last = link.timestamp;
        self.text = [NSString stringWithFormat:@"%.2f FPS", fps];
        [self sizeToFit];
        UIColor *color;
        if (fps >= 55) {
            color = [UIColor greenColor];
        } else if (45 <= fps) {
            color = [UIColor orangeColor];
        } else {
            color = [UIColor redColor];
        }
        self.backgroundColor = [color colorWithAlphaComponent:0.5];
    }
}

@end
