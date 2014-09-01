//
//  TBCitySBTableViewDataSource.h
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TBCitySBTableViewItem.h"



@class TBCitySBListModel,TBCitySBTableViewController,TBCitySBTableViewItem;

@protocol TBCitySBTableViewDataSource<UITableViewDataSource>

@required
/**
 * 指定cell的类型
 */
- (Class)cellClassForItem:(TBCitySBTableViewItem*)item AtIndex:(NSIndexPath *)indexPath;
/**
 *指定返回的item
 */
- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath;
/**
 *绑定items和model
 */
- (void)tableViewControllerDidLoadModel:(TBCitySBListModel*)model ForSection:(NSInteger)section;

@end

@interface TBCitySBTableViewDataSource : NSObject<TBCitySBTableViewDataSource>
/**
 * remote controller
 */
@property(nonatomic,weak)  TBCitySBTableViewController*  controller;
/**
 * <k:NSArray v:section>
 * section到列表数据的映射
 */
@property(nonatomic,strong)  NSDictionary* itemsForSection;
/**
 * <k:NSInterger v:section>
 * section到列表数据总数的映射
 */
@property(nonatomic,strong)  NSDictionary* totalCountForSection;

/**
 *  根据section为datasource赋值
 *
 *  @param items 被赋值的数据
 *  @param n     section
 */
- (void)setItems:(NSArray*)items ForSection:(NSInteger)n;

/**
 *  获取datasource中的数据
 *
 *  @param n 获取的section
 */
- (NSArray *)getItems:(int)section;

/**
 *  清除datasource中section部分的object
 *
 *  @param n 查找的的section
 *  @object  待清楚的object
 */
- (BOOL)removeObject:(id)object ForSection:(NSInteger)n; //删
/**
 *  清除datasource中的数据
 *
 *  @param n 待清除的section
 */
- (void)removeItemsForSection:(NSInteger)n;
/**
 *  清除datasource所有数据
 */
- (void)removeAllItems;



@end
