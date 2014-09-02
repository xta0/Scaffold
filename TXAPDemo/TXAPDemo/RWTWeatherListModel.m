// RWTWeatherListModel.m 
// iCoupon 
//created by moxin.xt on 2014-09-01 23:50:53 +0800. 
// Copyright (c) @taobao. All rights reserved.
// 

#import "RWTWeatherListModel.h"
#import "RWTWeatherListItem.h"

@implementation RWTWeatherListModel

- (NSDictionary* )dataParams{

    //todo:   

    return nil; 

}
- (NSDictionary* )mtopParams{

   //todo:    

    return nil; 

}
- (NSString* )methodName{

    return @"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json"; 

}
- (BOOL)useAuth{

     return NO; 

}
- (NSInteger)pageSize{

     return 10;

}
- (NSArray*)parseResponse:(id)JSON error:(NSError *__autoreleasing *)error{

    NSMutableArray* list = [NSMutableArray new];
    NSArray* weatherList = JSON[@"data"][@"weather"];
    
    for (NSDictionary* dict in weatherList) {
        
        RWTWeatherListItem* item = [RWTWeatherListItem new];
        [item autoKVCBinding:dict];
        item.itemHeight = 60;
        [list addObject:item];
        
    }
    return list;

}
@end

