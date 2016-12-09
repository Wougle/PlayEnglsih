//
//  UserDefaultsUtils.h
//
//  Created by Friday on 15/1/27.
//  Copyright (c) 2015年 Friday. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  ReLogin  存储是否重新登录（个人中心退出登录用到）
 */
@interface UserDefaultsUtils : NSObject
+(void)saveWithDic:(NSDictionary *)dic;

+(void)saveValue:(id) value forKey:(NSString *)key;

+(id)valueWithKey:(NSString *)key;

+(BOOL)boolValueWithKey:(NSString *)key;

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;

+(void)removeValueWithKey:(NSString *)key;

+(void)removeValueWithArray:(NSArray *)arr;

+(void)print;

@end
