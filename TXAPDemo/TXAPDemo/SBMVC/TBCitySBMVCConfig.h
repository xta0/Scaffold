//
//  TBCitySBMVCConfig.h
//  iCoupon
//
//  Created by moxin.xt on 14-5-6.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#ifndef iCoupon_TBCitySBMVCConfig_h
#define iCoupon_TBCitySBMVCConfig_h

#define __buildForMTOP__ 0


#import "TBCitySBTableViewDelegate.h"
#import "TBCitySBTableViewDataSource.h"
#import "TBCitySBViewController.h"
#import "TBCitySBTableViewController.h"
#import "TBCitySBRequest.h"
#import "TBCitySBItemList.h"
#import "TBCitySBModel.h"
#import "TBCitySBListModel.h"
#import "TBCitySBTableViewCell.h"
#import "TBCitySBTableViewCustomizedCell.h"
#import "TBCitySBTableViewErrorCell.h"
#import "TBCitySBTableViewLoadingCell.h"
#import "TBCitySBItem.h"
#import "TBCitySBTableViewItem.h"
#import "TBCitySBCustomizedTableViewItem.h"
#import "TBCitySBTableViewItem.h"
#import "TBCitySBTableViewFactory.h"


//define some globle things here
#undef	SBLog
#define SBLog(fmt,...)\
NSLog(@"[SB]-->" fmt, ## __VA_ARGS__); \


/**
 *  SBMVC => 1.2
 */
#define TBCitySBMVCErrorDomain @"TBCitySBMVCErrorDomain"

#define kMethodNameError 999
#define kParseJSONError 998
#define kLoginError 997
#define kRequestTimeout 996

#endif
