//
//  PYLCancelableOperation.h
//  PYLTiled
//
//  Created by yulei pang on 2019/2/20.
//  Copyright © 2019 pangyulei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYLCancelableOperation : NSOperation
@property (nonatomic, copy) void(^executeBlock)(PYLCancelableOperation *operation); 
@end
