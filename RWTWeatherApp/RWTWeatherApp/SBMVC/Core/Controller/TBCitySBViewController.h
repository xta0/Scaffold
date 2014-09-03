//
//  TBCitySBViewController.h
//  iCoupon
//
//  Created by Jason Wong on 14-1-2.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@class TBCitySBModel;
@protocol TBCitySBModelDelegate;
@class TBCitySBBusinessLogic;

#if __buildForMTOP__
@class TBCityViewController;
@interface TBCitySBViewController : TBCityViewController <TBCitySBModelDelegate>
#else
@interface TBCitySBViewController:UIViewController<TBCitySBModelDelegate>
#endif

{
@protected
    NSMutableDictionary* _modelDictInternal;
@protected
    BOOL _receiveMemoryWarning;
}


/**
 *  UI无关的业务逻辑
 */
@property(nonatomic,strong) TBCitySBBusinessLogic* logic;
/**
 *  modelDictionary
 */
@property(nonatomic,strong,readonly) NSDictionary* modelDictionary;
/**
 *  recv memory warning
 */
@property(nonatomic,assign,readonly) BOOL receiveMemoryWarning;
/**
 *  注册Model，用于Model和ViewController进行数据通讯
 *
 *  @param model 数据Model
 */
- (void)registerModel:(TBCitySBModel *)model;

/**
 *  解除已注册的Model
 *
 *  @param model 数据Model
 */
- (void)unRegisterModel:(TBCitySBModel *)model;

/**
 *  加载Model数据
 */
- (void)load;

/**
 *  重新加载Model数据
 */
- (void)reload;

/**
 *  加载更多Model数据，例如下一页
 */
- (void)loadMore;



@end


/**
 sub classing hooks
 */
@interface TBCitySBViewController(Subclassing)

- (void)didLoadModel:(TBCitySBModel*)model;

- (BOOL)canShowModel:(TBCitySBModel*)model;

- (void)showEmpty:(TBCitySBModel *)model;

- (void)showModel:(TBCitySBModel *)model ;

- (void)showLoading:(TBCitySBModel *)model;

- (void)showError:(NSError *)error withModel:(TBCitySBModel*)model;


@end

/**
 *  处理memory warning
 */
@interface TBCitySBViewController(MemoryWarning)
/**
 *  默认返回为YES，则由基类负责处理MemoryWarning
 *
 *  重载返回NO，则由子类实现MemoryWarning的逻辑
 *
 *  @return BOOL
 */
- (BOOL)shouldHandleMemoryWarning;

@end



