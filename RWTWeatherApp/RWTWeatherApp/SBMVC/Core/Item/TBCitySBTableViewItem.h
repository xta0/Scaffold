//
//  TBCitySBTableViewItem.h
//  iCoupon
//
//  Created by moxin.xt on 14-1-14.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBItem.h"

/**
 *  item的类型
 */
typedef NS_ENUM(int, TBCitySBTabViewItemType)
{
    /**
     *  默认类型，子类应该继承这个类型
     */
    kItem_Normal  = 0,
    /**
     *  loading类型，默认仅被父类使用
     */
    kItem_Loading = 1,
    /**
     *  错误类型，默认仅被父类使用
     */
    kItem_Error   = 2,
    /**
     *  自定一类型，默认仅被父类使用
     */
    kItem_Customize = 3
};

@interface TBCitySBTableViewItem : TBCitySBItem<NSCoding>

/**
 *  @required
 *  item的index
 */
@property (nonatomic,strong) NSIndexPath* indexPath;
/**
 *  @optional
 *  item的高度，建议在model请求完成后赋值
 */
@property (nonatomic,assign) CGFloat    itemHeight;
/**
 *  @optional
 *  item的数据类型
 */
@property (nonatomic,assign) TBCitySBTabViewItemType  itemType;
/**
 *  @optional
 *  item携带的image指针
 */
@property (nonatomic,strong) UIImage* image;
/**
 *  @optional
 *  item携带的imageUrl
 */
@property (nonatomic,strong) NSURL* imgUrl;
/**
 *  @optional
 *  item携带的imageUrl list，对象为NSURL
 */
@property (nonatomic,strong) NSMutableArray* imageUrlArray;


@end
