//
//  TBCitySBTableViewCell.h
//  iCoupon
//
//  Created by Jason Wong on 14-1-8.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBCitySBTableViewItem;

/**
 * cell的deleagte，如果cell上有UI元素需要点击传递给controller，使用这个delegate回调
 */
@protocol TBCitySBTableViewCellDelegate<NSObject>

@optional
- (void)onCellComponentClickedAtIndex:(NSIndexPath*)indexPath Bundle:(NSDictionary*)extra;

@end

@interface TBCitySBTableViewCell : UITableViewCell
/**
 *  cell的index
 */
@property (nonatomic,strong) NSIndexPath* indexPath;
/**
 *  cell绑定的item数据
 */
@property (nonatomic,strong) TBCitySBTableViewItem* item;
/**
 *  cell的delegate
 */
@property (nonatomic,weak) id<TBCitySBTableViewCellDelegate> delegate;

/**
 *  cell高度计算
 *
 *  @param tableView cell所在tableview
 *  @param item      cell对应的数据源
 *  @param indexPath cell的index
 *
 *  @return 高度值
 *  @important 这个方法在UI线程回调，如果需要很复杂的计算，请使用item.itemHeight字段。
 */
+ (CGFloat)tableView:(UITableView*)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath*)indexPath;




@end
