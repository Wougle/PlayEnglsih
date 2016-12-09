//
//  StudyProgressTableViewCell.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/30.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyProgressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *needHideLine;

@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@end
