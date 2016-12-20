//
//  HandlerBusiness.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/12/12.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "AFNetworking.h"

extern NSString *const ApiCodeGetStudyProgress;//学习进度

extern NSString *const ApiCodeGetWordLibrary;//单词库 复习库

extern NSString *const ApiCodeGetMusicList;//热门收藏

extern NSString *const ApiCodeGetUserData;//用户信息

extern NSString *const ApiCodeGetCommunityList;//社区评论列表

extern NSString *const ApiCodeGetReplyList;//回复列表

extern NSString *const ApiCodeGetReadListenSay;//首页列表

extern NSString *const ApiCodeSubmitReplyList;//发表评论

extern NSString *const ApiCodeSubmitCommunity;//

extern NSString *const ApiCodeChangeUserData;//

extern NSString *const ApiCodeUpdateFollow;

@interface HandlerBusiness : AFHTTPSessionManager

/**
 *  Handler处理完成后调用的Block
 */
typedef void (^CompletedBlock)();

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(id data , id msg);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailedBlock)(NSInteger code ,id errorMsg);


+(void)ServiceWithApicode:(NSString*)apicode Parameters:(NSDictionary*)parameters Success:(SuccessBlock)success Failed:(FailedBlock)failed Complete:(CompletedBlock)complete;

@end
