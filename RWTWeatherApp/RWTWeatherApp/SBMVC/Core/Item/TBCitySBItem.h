//
//  TBCitySBItem.h
//  iCoupon
//
//  Created by Jason Wong on 13-12-31.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#if __buildForMTOP__
#import "TBCityModel.h"
@interface TBCitySBItem : TBCityModel
#else
@interface TBCitySBItem : NSObject

#endif
/**
 *  自动进行KVC绑定
 *
 *  SBMVC => 1.1
 *
 *  @param dictionary
 */
- (void)autoKVCBinding:(NSDictionary* )dictionary;
/**
 *  SBMVC => 1.2
 *
 *  @return 序列化为dictionary
 */
- (NSDictionary* )toDictionary;

/**
 *  SBMVC => 1.2
 *
 *  @return 所有property的名称
 */
+ (NSSet* )propertyNames;


@end
