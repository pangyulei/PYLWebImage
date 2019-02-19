//
//  CADisplayLink+Safe.h
//  PYLFPSLabel
//
//  Created by yulei pang on 2019/2/18.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CADisplayLink (Safe)

+ (CADisplayLink *)pyl_displayLinkWithTarget:(id)target selector:(SEL)sel;

@end
