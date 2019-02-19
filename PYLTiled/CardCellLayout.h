//
//  CardCellLayout.h
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define textfont [UIFont systemFontOfSize:15]

@class CardModel;
@interface CardCellLayout : NSObject
@property(nonatomic,assign) double textHeight;
@property(nonatomic, assign) double cellHeight;
@property (nonatomic,assign) double textWidth;

- (instancetype)initWithCardCellModel:(CardModel *)model;

@end
