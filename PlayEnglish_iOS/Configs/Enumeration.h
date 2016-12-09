//
//  Enumeration.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 16/9/20.
//  Copyright © 2016年 DMT. All rights reserved.
//

#ifndef Enumeration_h
#define Enumeration_h

typedef NS_ENUM(NSInteger, RLSModelState) {
    RLSReadState = 1,        //看模式
    RLSListenState,          //听模式
    RLSSayState,             //说模式
};

typedef NS_ENUM(NSInteger, RLSJudgeYesOrNo) {
    RLSWordIsNull  = 0,               //未做判断
    RLSWordIsRight,                   //正确
    RLSWordIsWrong,                   //错误
};

#endif /* Enumeration_h */
