//
//  CardModel.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "CardModel.h"
#import "CardCellLayout.h"
@implementation CardModel

- (instancetype)init {
    self = [super init];
    self.text = [self randomText];
    return self;
}

- (NSString *)randomText {
    int l = arc4random_uniform(300);
    NSMutableString *s = @"".mutableCopy;
    for(int i=0;i<l;i++) {
        [s appendString:@"y"];
    }
    return s;
}

- (CardCellLayout *)layout {
    //pang todo 优化布局缓存
    if (!_layout) {
        _layout = [[CardCellLayout alloc] initWithCardCellModel:self];
    }
    return _layout;
}


@end
