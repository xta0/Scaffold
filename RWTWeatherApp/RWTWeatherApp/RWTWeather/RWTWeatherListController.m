// RWTWeatherListController.m 
// iCoupon 
//created by moxin.xt on 2014-09-03 23:48:15 +0800. 
// Copyright (c) @taobao. All rights reserved.
// 

#import "RWTWeatherListController.h" 
#import "RWTWeatherListModel.h" 
#import "RWTWeatherListDataSource.h" 
#import "RWTWeatherListDelegate.h" 
#import "RWTWeatherLogic.h"  

@interface RWTWeatherListController ()

@property(nonatomic,strong)RWTWeatherListModel *weatherListModel;
@property(nonatomic,strong)RWTWeatherListDataSource *ds;
@property(nonatomic,strong)RWTWeatherListDelegate *dl;
@end

@implementation RWTWeatherListController 

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 



-(RWTWeatherListModel* )weatherListModel{

 if(!_weatherListModel) {
      _weatherListModel = [RWTWeatherListModel new];
     _weatherListModel.requestType = TBCitySBModelAFNetworking;
      _weatherListModel.key = @"__RWTWeatherListModel__";
   }
   return _weatherListModel;
}

- (RWTWeatherListDataSource* )ds{

  if (!_ds) {
      _ds = [RWTWeatherListDataSource new];
   }
   return _ds;
}

- (RWTWeatherListDelegate* )dl{

  if (!_dl) {
      _dl = [RWTWeatherListDelegate new];
   }
   return _dl;
}

//////////////////////////////////////////////////////////// 
#pragma mark - life cycle 

-(id)init{

   self = [super init];

    if (self) {

     self.logic = [RWTWeatherLogic new];

   }

   return self;

}

- (void)loadView{ 

    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLoad{ 

    [super viewDidLoad]; 

    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = YES;

    self.tableView.contentOffset = CGPointMake(0, -64);

    //2,set some properties:下拉刷新，自动翻页
    self.bNeedLoadMore = NO;
    self.bNeedPullRefresh = YES;

    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    self.keyModel = self.weatherListModel;

    //5,REQUIRED:register model to parent view controller
    [self registerModel:self.weatherListModel];

    //6,load model
    [self load];

}

- (void)didReceiveMemoryWarning{ 

    [super didReceiveMemoryWarning]; 



}

- (void)dealloc{ 

}

//////////////////////////////////////////////////////////// 
#pragma mark - TBCitySBViewController 



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

  //todo:... 

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{

  //todo:... 

}

//////////////////////////////////////////////////////////// 
#pragma mark - public method 



//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 



//////////////////////////////////////////////////////////// 
#pragma mark - private method 



@end 

