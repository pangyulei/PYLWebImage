//
//  CardModel.h
//  PYLTiled
//
//  Created by yulei pang on 2019/2/19.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CardCellLayout;

@interface CardModel : NSObject
@property (nonatomic, copy) NSString *text;
@property(nonatomic)CardCellLayout *layout;
@end
