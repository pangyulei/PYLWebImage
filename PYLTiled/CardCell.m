//
//  CardCell.m
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import "CardCell.h"
#import "UIImageView+PYL.h"
#import "CardModel.h"
#import "CardCellLayout.h"
#import "UIImage+PYL.h"

@interface CardCell ()
@property (nonatomic) UIImageView *avatar;
@property (nonatomic) UILabel *label;
@end

@implementation CardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor whiteColor];
    _avatar = [UIImageView new];
    _avatar.contentMode = UIViewContentModeScaleToFill;
    _avatar.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_avatar];
    
    _label = [UILabel new];
    //pang todo 优化阴影
//    _label.layer.shadowRadius = 5;
//    _label.layer.shadowOffset = CGSizeMake(0, 1);
//    _label.layer.shadowOpacity = 1;
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
    __weak typeof(self) weakself = self;
    [_avatar pyl_setImageURL:model.url placeholder:nil completion:^UIImage *(UIImage *image, BOOL fromCache) {
        UIImage *roundImage;
        if (fromCache) {
            roundImage = image;
        } else {
            roundImage = [image imageByRoundCornerRadius:25];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:weakself.avatar duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                weakself.avatar.image = roundImage;
            } completion:nil];
        });
        return roundImage;
    }];
    
    _avatar.frame = CGRectMake(16, 16, 50, 50);
    _label.frame = CGRectMake(82, 16, model.layout.textWidth, model.layout.textHeight);
    _label.text = model.text;
}

@end
