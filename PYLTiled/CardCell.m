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
#import "CardCellLayer.h"

@interface CardCell ()
@property (nonatomic) UIImageView *avatar;
@property (nonatomic) UIImageView *xxxx;
@property (nonatomic) UILabel *label;
@property (nonatomic) CALayer *shadowLayer;
@end

@implementation CardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    _shadowLayer = [CALayer layer];
    _shadowLayer.shadowRadius = 5;
    _shadowLayer.shadowOpacity = 1;
    [self.contentView.layer addSublayer:_shadowLayer];
    
    
    _avatar = [UIImageView new];
    _avatar.contentMode = UIViewContentModeScaleToFill;
    _avatar.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_avatar];
    
   
    
    _label = [UILabel new];
    _label.numberOfLines = 0;
    _label.font = textfont;
    _label.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_label];
    
    _xxxx = [UIImageView new];
    _xxxx.contentMode = UIViewContentModeScaleToFill;
    _xxxx.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_xxxx];

    return self;
}

+ (Class)layerClass {
    return [CardCellLayer class];
}

- (void)asyncDraw:(UIImage*)image {
    _xxxx.image = image;
}

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
    _xxxx.frame = CGRectMake(82, 16, 50, 50);
    _label.frame = CGRectMake(82, 16, model.layout.textWidth, model.layout.textHeight);
    _label.text = model.text;
    _shadowLayer.shadowPath = [UIBezierPath bezierPathWithRect:_label.bounds].CGPath;
    _shadowLayer.frame = _label.frame;
    [self.layer setNeedsDisplay];
}

@end
