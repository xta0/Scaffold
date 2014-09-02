// RWTWeatherListCell.h 
// iCoupon 
//created by moxin.xt on 2014-09-02 14:31:36 +0800. 
// Copyright (c) @taobao. All rights reserved.
// 



@class TBCitySBTableViewCell;
@class RWTWeatherListItem;

@interface RWTWeatherListCell : TBCitySBTableViewCell

@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* dateLabel;
@property(nonatomic,strong)UILabel* minLabel;
@property(nonatomic,strong)UILabel* toLabel;
@property(nonatomic,strong)UILabel* maxLabel;
@property(nonatomic,strong)UILabel* stateLabel;



@end
