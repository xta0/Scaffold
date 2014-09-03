//
//  TBCitySBRequest.m
//  iCoupon
//
//  Created by Jason Wong on 14-1-2.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCitySBRequest.h"

@interface TBCitySBRequest()

@end

@implementation TBCitySBRequest

@synthesize delegate    = _delegate;
@synthesize useAuth     = _useAuth;
@synthesize useCache    = _useCache;
@synthesize usePost     = _usePost;
@synthesize showLogin   = _showLogin;
@synthesize responseObject = _responseObject;
@synthesize responseString = _responseString;
@synthesize apiCacheTimeOutSeconds = _apiCacheTimeOutSeconds;

- (void)initRequestWithBaseURL:(NSString*)url
{
    
}
- (void)addParams:(NSDictionary* )aParams forKey:(NSString*)key
{
    
}
- (void)addBodyData:(NSDictionary *)aData forKey:(NSString *)key
{

}
- (void)load
{
    
}
- (void)cancel
{
    
}

@end