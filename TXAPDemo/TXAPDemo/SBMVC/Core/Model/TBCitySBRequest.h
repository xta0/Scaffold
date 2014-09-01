//
//  TBCitySBRequest.h
//  iCoupon
//
//  Created by Jason Wong on 14-1-2.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *   TBCitySBRequest：
 *
 *   v: SBMVC => 1.1
 *
 *  （1）TBCitySBRequest从继承MTOPRequet改为接口实现，不耦合具体业务，改为普通HTTP请求
 *
 *  （2）原MTOPRequest的逻辑（sid失效，重登等）分离到TBCitySBMTOPRequest的适配层
 *
 *  （3）TBCitySBModel对HTTP request改为接口依赖，第三方Request（如MTOP）需要实现<TBCitySBRequest>接口
 *
 */
@protocol TBCitySBRequest;

@protocol TBCitySBRequestDelegate <NSObject>

@required

- (void)requestDidStartLoad:(id<TBCitySBRequest> )request;
- (void)requestDidFinish:(id)JSON;
- (void)requestDidFailWithError:(NSError *)error;

@end

@protocol TBCitySBRequest <NSObject>

@property (nonatomic) BOOL useAuth;
@property (nonatomic) BOOL showLogin;
@property (nonatomic) BOOL useCache;
@property (nonatomic) BOOL usePost;
@property (nonatomic,assign) NSTimeInterval apiCacheTimeOutSeconds;
@property (nonatomic,weak) id<TBCitySBRequestDelegate> delegate;

/**
 * 
 *  增加返回的response string/obj
 *
 *  v = SBMVC : 1.2
 */
@property (nonatomic,strong,readonly) NSString* responseString;
@property(nonatomic,strong,readonly) id responseObject;

/**
 *  创建请求的request
 *
 *  @param url
 */
- (void)initRequestWithBaseURL:(NSString*)url;
/**
 *  增加HTTP GET请求参数
 *
 *  @param aParams 参数
 *  @param key     不同参数类型对应的key
 */
- (void)addParams:(NSDictionary* )aParams forKey:(NSString*)key;
/**
 *  增加HTTP的POST请求参数
 *
 *   v = SBMVC : 1.2
 *
 *   @param aData POST请求的BODY数据
 *   @param key 对应的key
 */
- (void)addBodyData:(NSDictionary* )aData forKey:(NSString* )key;
/**
 *  发起请求
 */
- (void)load;
/**
 *  取消请求
 */
- (void)cancel;


@end

@interface TBCitySBRequest : NSObject<TBCitySBRequest>

@end


