//
//  TBCitySBTableViewFactory.h
//  iCoupon
//
//  Created by moxin.xt on 14-1-16.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  生成footerview的工厂类
 */
@interface TBCitySBTableViewFactory : NSObject

+ (UIView*)getClickableFooterView:(CGRect)frame Text:(NSString*)text Target:(id)target Action:(SEL)action;
+ (UIView*)getNormalFooterView:(CGRect)frame Text:(NSString*)text;
+ (UIView*)getLoadingFooterView:(CGRect)frame Text:(NSString*)text;
+ (UIView*)getErrorFooterView:(CGRect)frame Text:(NSString*)text;

@end
