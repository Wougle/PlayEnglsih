//
//  RlsViewController.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/10/15.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RlsViewController : UIViewController

@property(nonatomic,strong)NSString *videoURL;//用于加载视频
@property(nonatomic,strong)NSString *musicName;//用于加载歌词
@property(nonatomic,strong)NSString *titleName;//歌曲名
@property(nonatomic,strong)NSString *imageName;//歌曲图片名
@property(nonatomic,assign)BOOL isLike;        //是否点过赞
@property(nonatomic,strong)NSString *lookedPerson;//观看人数

@end
