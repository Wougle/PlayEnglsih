//
//  PEDetailTableViewCell.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/16.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *speakLikeBtn;
@property (weak, nonatomic) IBOutlet UILabel *speakContentLabel;

@end
