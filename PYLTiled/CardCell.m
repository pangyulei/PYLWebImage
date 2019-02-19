//
//  CardCell.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "CardCell.h"
#import "UIImageView+Web.h"
#import "CardModel.h"
#import "CardCellLayout.h"

@interface CardCell ()
@property (nonatomic) UIImageView *avatar;
@property (nonatomic) UILabel *label;
@end

@implementation CardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _avatar = [UIImageView new];
    //pang todo 优化圆角
    _avatar.layer.cornerRadius = 25;
    _avatar.clipsToBounds = YES;
    _avatar.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_avatar];
    
    _label = [UILabel new];
    //pang todo 优化阴影
    _label.layer.shadowRadius = 5;
    _label.layer.shadowOffset = CGSizeMake(0, 1);
    _label.layer.shadowOpacity = 1;
    _label.numberOfLines = 0;
    _label.font = textfont;
    [self.contentView addSubview:_label];
    
    return self;
}
//pang todo 优化异步绘制
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//
//}

- (void)configWithModel:(CardModel *)model {
    [_avatar setWithUrl:[NSURL URLWithString:@"https://source.unsplash.com/random/50x50"]];
    _avatar.frame = CGRectMake(16, 16, 50, 50);
    _label.frame = CGRectMake(82, 16, model.layout.textWidth, model.layout.textHeight);
    _label.text = model.text;
}

@end
