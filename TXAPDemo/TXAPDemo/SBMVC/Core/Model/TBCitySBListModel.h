//
//  TBCitySBTableViewModel.h
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBModel.h"

/**
 *  列表model的翻页模式
 */
typedef NS_OPTIONS(NSUInteger, TBCitySBModelPageMode) {
    /**
     *  有数据回来就自动翻页，否则停止翻页
     */
    TBCitySBModelPageDefault        = 0,
    /**
     *  有数据回来，如果数量小于pagesize，则停止翻页
     *  有数据回来，且数量等于pagesize，则自动翻页
     *  没有数据回来，则停止翻页
     */
    TBCitySBModelPageReturnCount    = 1,
    /**
     *  翻页依据自定义的totalCount，不依赖pagesize
     */
    TBCitySBModelPageCustomize      = 2
};


@interface TBCitySBListModel : TBCitySBModel

@property (nonatomic, readonly) BOOL hasMore;

/**
 *  分页模式，默认是 TBCitySBModelPageDefault
 */
@property (nonatomic, assign) TBCitySBModelPageMode pageMode;

/**
 * 分页当前页数
 */
@property(nonatomic, assign) NSInteger currentPageIndex;

/**
 * 列表总条数，根据 pageMode
 * 如果pageMode == TBCitySBModelPageCustomize，那么totalCount才生效
 */
@property(nonatomic, assign) NSInteger totalCount;

/**
 *  分页个数，默认20
 */
@property(nonatomic, assign) NSInteger pageSize;
/**
 *  对应的section
 */
@property(nonatomic, assign) NSInteger sectionNumber;

@end
