//
//  PEDetailViewController.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/25.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDetailViewController : UIViewController
@property (assign,nonatomic) NSInteger number; //
@property (assign,nonatomic) NSInteger viewType; //1 社区   2 我的收藏
@property (assign,nonatomic) BOOL isReply; //是否是点击回复进来
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (nonatomic, assign)NSInteger commID;

@end
