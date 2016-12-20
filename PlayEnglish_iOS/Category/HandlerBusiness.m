//
//  HandlerBusiness.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/12/12.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "HandlerBusiness.h"
#import "YYModel.h"
#define BaseURLString  @"http://localhost:3000/"

static HandlerBusiness *_sharedManager = nil;
static dispatch_once_t onceToken;

NSString *const ApiCodeGetStudyProgress = @"getStudyProgress";

NSString *const ApiCodeGetWordLibrary = @"getWordLibrary";

NSString *const ApiCodeGetMusicList = @"getMusicList";

NSString *const ApiCodeGetUserData = @"getUserData";

NSString *const ApiCodeGetCommunityList = @"getCommunityList";

NSString *const ApiCodeGetReplyList = @"getReplyList";

NSString *const ApiCodeGetReadListenSay = @"getReadListenSay";

NSString *const ApiCodeSubmitReplyList = @"submitReplyList";

NSString *const ApiCodeSubmitCommunity = @"submitCommunity";

NSString *const ApiCodeChangeUserData = @"changeUserData";

NSString *const ApiCodeUpdateFollow = @"updateFollow";

@implementation HandlerBusiness

+(void)ServiceWithApicode:(NSString*)apicode Parameters:(NSDictionary*)parameters Success:(SuccessBlock)success Failed:(FailedBlock)failed Complete:(CompletedBlock)complete{
    dispatch_once(&onceToken, ^{
        _sharedManager = [[HandlerBusiness alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",nil];
    });
    if (parameters==nil) {
        parameters = @{};
    }
    [_sharedManager POST:apicode parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(complete != nil){
            complete();
            DBG(@"complete");
        }
        NSString *modelStr = [HandlerBusiness mapModel][apicode];
        if (modelStr!=nil && ![modelStr isEqualToString:@""]) {
            Class cla = NSClassFromString(modelStr);
            if (!cla) {
                NSLog(@"找不到对应模型类，%@", modelStr);
            }
            success([cla yy_modelWithJSON:responseObject],responseObject);
            DBG(@"success");
        }
        else{
            success(responseObject,responseObject);
            DBG(@"success");
        }
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if(complete != nil){
            complete();
        }
        DBG(@"failure");
        failed([@-9999 integerValue] , @{@"prompt":@"网络错误",@"error":@"网络错误或接口调用失败"});
    }];
}

+(NSDictionary *)mapModel
{
    //TODO:对应 model
    return @{
             //             ApiCodeGetUserInfo:@"GetUserInfoModel",
             };
}
@end
