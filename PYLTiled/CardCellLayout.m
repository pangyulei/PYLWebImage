//
//  CardCellLayout.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "CardCellLayout.h"
#import "CardModel.h"

static double ksw = 0;
@implementation CardCellLayout

- (instancetype)initWithCardCellModel:(CardModel *)model {
    self = [super init];
    self.textHeight = [self textHeightWithModel:model];
    self.cellHeight = [self cellHeightWithTextHeight:_textHeight];
    self.textWidth = [self screenWidth] - 50 - 16*3;
    return self;
}

- (double)textHeightWithModel:(CardModel *)model {
    double width = [self screenWidth] - 50 - 16*3;
    CGRect rect = [model.text boundingRectWithSize:CGSizeMake(width, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textfont} context:nil];
    return rect.size.height;
}

- (double)screenWidth {
    if (ksw == 0) {
        ksw = [UIScreen mainScreen].bounds.size.width;
    }
    return ksw;
}

- (double)cellHeightWithTextHeight:(double)textHeight {
    return MAX(16*2+textHeight, 16*2+50);
}

@end
