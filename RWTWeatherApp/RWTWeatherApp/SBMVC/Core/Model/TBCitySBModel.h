//
//  TBCitySBModel.h
//  iCoupon
//
//  Created by Jason Wong on 13-12-31.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBCitySBItemList.h"
#import "TBCitySBRequest.h"

/**
 * Model的状态
 *
 * v= SBMVC=>1.1:增加finished
 */
typedef NS_OPTIONS(NSInteger, TBCitySBModelState) {
    TBCitySBModelStateError     = -1,
    TBCitySBModelStateReady     = 0,
    TBCitySBModelStateLoading   = 1,
    TBCitySBModelStateFinished  = 2

};

typedef NS_OPTIONS(NSUInteger, TBCitySBModelResponseMode) {
    TBCitySBModelResponseDefault    = 0,
    TBCitySBModelResponseList       = 1,
    TBCitySBModelResponseData       = 2
};

/**
 *  model的http请求类型
 */
typedef NS_ENUM(NSInteger,TBCitySBModelRequestType)
{
    /**
     *  MTOP请求，使用TBCitySBMTopRequest
     */
    TBCitySBModelMTOP = 0,
    /**
     *  普通HTTP请求，使用TBCitySBAFRequet
     */
    TBCitySBModelAFNetworking = 1,
    /**
     *  使用第三方request，需要实现<TBCitySBRequest>
     */
    TBCitySBModelCustom
};



@class TBCitySBModel;

typedef void(^TBCitySBModelCallback) (TBCitySBModel* model, NSError* error);

@protocol TBCitySBModelDelegate <NSObject>

@optional
- (void)modelDidStart:(TBCitySBModel *)model;
- (void)modelDidFinish:(TBCitySBModel *)model;
- (void)modelDidFail:(TBCitySBModel *)model withError:(NSError *)error;

@end


// 子类需要重写的方法
@protocol TBCitySBModel <NSObject>

@required

/**
 *  MTop请求业务数据，例如业务的入参
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dataParams;


/**
 *  MTop的签名数据，例如版本号，SID等
 *
 *  @return NSDictionary
 */
- (NSDictionary *)mtopParams;

/**
 *  MTop API Name
 *
 *  @return NSString
 */
- (NSString *)methodName;

/**
 *  解析MTop返回的JSON，并返回结果给Model来处理
 *  如果解析JSON错误，请设置error，并返回nil
 *
 *  @param JSON 请求返回的JSON结果
 *  @param error 如果解析JSON错误，请设置error
 *
 *  @return NSArray
 */
- (NSArray *)parseResponse:(id)JSON error:(NSError **)error;

@optional

/**
 *  是否使用Cache，默认NO
 *
 *  @return BOOL
 */
- (BOOL)useCache;

/**
 *  是否使用账号验证逻辑，例如一些需要登录的接口，需要设置。默认NO
 *
 *  @return BOOL
 */
- (BOOL)useAuth;


/**
 *  如果没有登录，是否需要弹出登陆框进行登录；默认为YES
 *
 *  @return BOOL
 */
- (BOOL)needManualLogin;

/**
 *  api cache的cache时长
 *  @return NSTimeInterval
 */
- (NSTimeInterval)apiCacheTimeOutSeconds;

/**
 *  如果requestType指定为custom，则这个方法要返回第三方request的类名
 *
 *  v = SBMVC : 1.1
 *
 *  @return 第三方request的类名
 */
- (NSString* )customRequestClassName;
/**
 *  MTOP POST 请求的body参数
 *
 *  v = SBMVC : 1.2
 *
 *  @return {key => NSString,文件名，需要后缀 : data => NSData，上传的文件}
 */
- (NSDictionary* )bodyData;

/**
 *  是否是POST请求
 *
 *  v = SBMVC : 1.2
 */
- (BOOL)isPost;

@end



@interface TBCitySBModel : NSObject<TBCitySBModel>

/**
 *  model的请求类型：mtop / af networking
 *
 *  v = SBMVC => 1.1
 */
@property(nonatomic,assign) TBCitySBModelRequestType requestType;
/**
 * Model的状态
 *
 * v= SBMVC=>1.1
 */
@property (nonatomic, assign,readonly) TBCitySBModelState state;
/**
 *  Model的delegate，用于发送Model状态
 */
@property(nonatomic, weak) id<TBCitySBModelDelegate> delegate;

/**
 *  数据列表
 */
@property(nonatomic, strong, readonly) TBCitySBItemList *itemList;

/**
 *  错误对象，默认为nil
 */
@property(nonatomic, strong,readonly) NSError *error;

/**
 *  Model的key，用于标识Model
 */
@property(nonatomic,strong) NSString* key;
/**
 *  返回的response 对象
 *
 *  v：SBMVC=>1.2
 */
@property(nonatomic,strong,readonly) id responseObject;
/**
 *  返回的response string
 *
 *  v：SBMVC=>1.2
 */
@property(nonatomic,strong,readonly) NSString* responseString;

/**
 *  model的请求操作，回调使用delegate
 */
- (void)load;
/**
 * model的请求操作，回调使用block
 *
 * v：SBMVC=>1.1
 *
 * 使用这个方法需要注意：
 * model的状态不会和controller耦合，对界面的更新放到回调中执行
 * 注意block中使用__weak，避免循环引用！
 *
 */
- (void)loadWithCompletion:(TBCitySBModelCallback)aCallback;
/**
 *  model重新请求，回调使用delegate
 */
- (void)reload;
/**
 * model的重新请求操作，回调使用block
 *
 * v：SBMVC=>1.1
 *
 * 使用这个方法需要注意：
 * model的状态不会和controller耦合，对界面的更新放到回调中执行
 * 注意block中使用__weak，避免循环引用！
 */
- (void)reloadWithCompletion:(TBCitySBModelCallback)aCallback;
/**
 *  model加载更多的请求
 */
- (void)loadMore;
/**
 *  取消model请求
 */
- (void)cancel;
/**
 *  清空model数据，重置model的状态
 */
- (void)reset;

- (void)requestDidStartLoad:(TBCitySBRequest *)request;
- (void)requestDidFinish:(id)JSON;
- (void)requestDidFailWithError:(NSError *)error;


- (BOOL)isLoading;

@end