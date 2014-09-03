//
//  TBCitySBBusinessLogic.h
//  iCoupon
//
//  Created by moxin.xt on 14-9-3.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBCitySBViewController;

@protocol TBCitySBBusinessLogicInterface <NSObject>

@optional
- (void)onControllerShouldPerformAction:(int)type args:(NSDictionary* )dict;

@end

@interface TBCitySBBusinessLogic : NSObject

@property(nonatomic,weak)id<TBCitySBBusinessLogicInterface> viewController;

- (void)logic_view_did_load;

- (void)logic_view_will_appear;

- (void)logic_view_did_appear;

- (void)logic_view_will_disappear;

- (void)logic_view_did_disappear;

- (void)logic_dealloc;

@end
