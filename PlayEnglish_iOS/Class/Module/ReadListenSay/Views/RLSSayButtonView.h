//
//  RLSSayButtonView.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/13.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLSSayButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *lastVoiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordVoiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextVoiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *userTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *timeBackView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userResultLabel;

@end
