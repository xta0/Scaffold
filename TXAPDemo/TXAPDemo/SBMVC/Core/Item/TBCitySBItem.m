//
//  TBCitySBItem.m
//  iCoupon
//
//  Created by Jason Wong on 13-12-31.
//  Copyright (c) 2013年 Taobao.com. All rights reserved.
//

#import "TBCitySBItem.h"
#include <objc/runtime.h>
//cached property keys
static void *SBItemCachedPropertyKeysKey = &SBItemCachedPropertyKeysKey;

typedef NS_ENUM(int , ENCODE_TYPE)
{
    KUnknown = -1,
    kValue=0,
    kStruct,
    kUnion,
    kPointer,
    kObject
};

@implementation TBCitySBItem
{
    enum ENCODE_TYPE _encodeType;
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - class API
/**
 *  SBMVC => 1.2
 *
 *  @return 所有property的名称
 */
+ (NSSet* )propertyNames
{
    NSSet *cachedKeys = objc_getAssociatedObject(self, SBItemCachedPropertyKeysKey);
	if (cachedKeys != nil) return cachedKeys;
    
    NSMutableSet* set = [NSMutableSet new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        
        //get property name
        const char *propName = property_getName(property);
        
        //chect value for key is not nil!!
        NSString *propertyName = @(propName);
        
        [set addObject:propertyName];
        
    }
    
    //cache sets
	objc_setAssociatedObject(self, SBItemCachedPropertyKeysKey, set, OBJC_ASSOCIATION_COPY);
    return set;
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public  API


- (void)autoKVCBinding:(NSDictionary* )dictionary
{
    //test value for key != nil
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        
        //get property name
        const char *propName = property_getName(property);
        
        //chect value for key is not nil!!
        NSString *propertyName = [NSString stringWithUTF8String:propName];
        
        //get propertyClass
        Class propertyClass = nil;
        
        const char* attr = property_getAttributes(property);
        NSString* propAttr = [NSString stringWithUTF8String:attr];
        
        //remove "T"
        propAttr = [propAttr substringFromIndex:1];
        
        //get @encode(),@property,V_
        NSArray * attributes = [propAttr componentsSeparatedByString:@","];
        
        //get @encode()
        NSString* typeAttr = attributes[0];
        
        ENCODE_TYPE encodeType = [self encodeType:typeAttr];
        
        
        //只对object赋值
        if (encodeType == kObject) {
            
            NSString* tmp = [typeAttr substringWithRange:NSMakeRange(2, typeAttr.length-3)];
            propertyClass = NSClassFromString(tmp);
        }
        else
        {
            [self setValue:nil forKey:propertyName];
        }
        if (!propertyClass) {
            continue;
        }
        
        //get value from dictionary
        id val = dictionary[propertyName];
        
        if (val && [val isKindOfClass:propertyClass]) {
            
            [self setValue:val forKey:propertyName];
            
        }
        else
            [self setValue:nil forKey:propertyName];
        
    }
    free(properties);
    
    
}

- (NSDictionary* )toDictionary
{
    return [self dictionaryWithValuesForKeys:self.class.propertyNames.allObjects];
}

- (NSString* )description
{
    return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, self.toDictionary];
}



////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - private tool  API
/**
 *  确定@encode的类型
 *
 *  SBMVC => 1.2
 *
 *  @return @encode的返回值
 */
- (ENCODE_TYPE)encodeType:(NSString* )type
{
    //char,double,int/enum/signed,float,long,unsigned
    NSArray* values = @[@"c",@"d",@"i",@"f",@"l",@"I"];
    
    ENCODE_TYPE ret = KUnknown;
    
    
    NSString* firstChar = [type substringToIndex:1];
    
    
    //value
    if ([values containsObject:firstChar]) {
        
        if ([values containsObject:type]) {
            ret = kValue;
        }
    }
    
    //struct
    else if ([firstChar isEqualToString:@"{"])
    {
        ret = kStruct;
    }
    
    //union
    else if ([firstChar isEqualToString:@"("])
    {
        ret = kUnion;
        
    }
    
    //pointer
    else if([firstChar isEqualToString:@"^"])
    {
        ret = kPointer;
    }
    
    //object
    else if ([firstChar isEqualToString:@"@"])
    {
        ret = kObject;
    }
    else
        ret = -1;
    
    return ret;
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - KVC hooks

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    SBLog(@"WARNING: Set value for undefiend key %s", [key UTF8String]);
}

- (void)setNilValueForKey:(NSString *)key
{
    SBLog(@"WARNING: Set nil value for key %s",  [key UTF8String]);
}

- (id)valueForUndefinedKey:(NSString *)key {
    SBLog(@"WARNING: Get value for undefiend key %s", [key UTF8String]);
    return nil;
}

@end
