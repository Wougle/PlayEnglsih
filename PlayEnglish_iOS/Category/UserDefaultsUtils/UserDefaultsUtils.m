//
//  UserDefaultsUtils.m
//
//  Created by Friday on 15/1/27.
//  Copyright (c) 2015年 Friday. All rights reserved.
//

#import "UserDefaultsUtils.h"

@implementation UserDefaultsUtils
+(void)saveWithDic:(NSDictionary *)dic
{
    NSArray * arrKeys=[dic allKeys];
    if (arrKeys.count>0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        for (int i=0; i<arrKeys.count; i++) {
            [userDefaults setValue:dic[arrKeys[i]] forKey:arrKeys[i]];
        }
        [userDefaults synchronize];
    }
}

+(void)saveValue:(id) value forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+(id)valueWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(BOOL)boolValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}
+(void)removeValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

+(void)removeValueWithArray:(NSArray *)arr
{
    if (arr&&arr.count>0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        for (int i=0; i<arr.count; i++) {
            [userDefaults removeObjectForKey:arr[i]];
        }
        [userDefaults synchronize];
    }
   
}
+(void)print{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    DBG(@"%@",dic);
}

@end
