// RWTWeatherListItem.h 
// iCoupon 
//created by moxin.xt on 2014-09-03 23:48:15 +0800. 
// Copyright (c) @taobao. All rights reserved.
// 



@class TBCitySBTableViewItem;

@interface RWTWeatherListItem : TBCitySBTableViewItem

@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *precipMM;
@property(nonatomic,strong)NSString *tempMaxC;
@property(nonatomic,strong)NSString *tempMaxF;
@property(nonatomic,strong)NSString *tempMinC;
@property(nonatomic,strong)NSString *tempMinF;
@property(nonatomic,strong)NSString *weatherCode;
@property(nonatomic,strong)NSArray *weatherDesc;
@property(nonatomic,strong)NSArray *weatherIconUrl;
@property(nonatomic,strong)NSString *winddir16Point;
@property(nonatomic,strong)NSString *winddirDegree;
@property(nonatomic,strong)NSString *winddirection;
@property(nonatomic,strong)NSString *windspeedKmph;
@property(nonatomic,strong)NSString *windspeedMiles;



@end
