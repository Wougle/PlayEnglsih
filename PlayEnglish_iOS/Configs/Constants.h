//
//  Constants.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 16/9/20.
//  Copyright © 2016年 DMT. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define kTimeSpan 1.5
//color
#define Rgb2UIColor(r, g, b, a)        [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:((a)/1.0)]
#define THEME_COLOR Rgb2UIColor(228 , 75, 59, 1) //主色 红

#define BG_COLOR Rgb2UIColor(243 , 243, 243, 1) //底色
#define TEXT_COLOR_MAIN Rgb2UIColor(136 , 136, 136, 1) //主要文字颜色
#define TEXT_COLOR_SECONDARY Rgb2UIColor(80 , 72, 75, 1) //次要文字颜色 歌词黑色
#define TEXT_COLOR_THIRDARY Rgb2UIColor(131 , 125, 127, 1) //次要文字颜色 歌词灰色
#define LINE_COLOR Rgb2UIColor(230 , 230, 230, 1) // 线条颜色


//size
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define SCREEN_WIDTH  ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

//APP INFO
#define APP_DISPLAYNAME     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define ALERT_TITLE APP_DISPLAYNAME
#define VERSION             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define SystemVersion [[UIDevice currentDevice] systemVersion]
#define SystemBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


#ifdef DEBUG
#define DBG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define DBG(format, ...)
#endif


#define IS_NULL_STRING(__POINTER) \
(__POINTER == nil || \
__POINTER == (NSString *)[NSNull null] || \
![__POINTER isKindOfClass:[NSString class]] || \
![__POINTER length])

#define g_myself [MySelfInfo sharedMySelfInfo]

#endif /* Constants_h */
