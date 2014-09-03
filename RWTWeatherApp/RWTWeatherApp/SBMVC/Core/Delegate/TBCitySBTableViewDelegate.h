//
//  TBCitySBTableViewDelegate.h
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBCitySBTableViewController;
@protocol TBCitySBTableViewDelegate <UITableViewDelegate>
@end


@interface TBCitySBTableViewDelegate : NSObject<TBCitySBTableViewDelegate>


@property(nonatomic,assign) BOOL bScrolling;
/**
 * a weak reference to view controller
 */
@property (nonatomic, weak) TBCitySBTableViewController* controller;

@end
