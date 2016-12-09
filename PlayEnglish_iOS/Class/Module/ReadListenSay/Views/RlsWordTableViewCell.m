//
//  RlsWordTableViewCell.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/10/20.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "RlsWordTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@implementation RlsWordTableViewCell

-(void)awakeFromNib
{
    self.meansLabel.frame = CGRectMake(30, 78, SCREEN_WIDTH -63, 36);
    [super awakeFromNib];
    self.addBtn.layer.cornerRadius = 15.f;
    self.addBtn.layer.masksToBounds  = YES;
    self.addBtn.layer.borderWidth = 1.f;
    self.addBtn.layer.borderColor = THEME_COLOR.CGColor;
    [self.addBtn addTarget:self action:@selector(addThisWord) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceBtn addTarget:self action:@selector(listenThisVoice) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addThisWord{
    NSLog(@"addThisWord");
    if (!_addBtn.isSelected) {
        _addBtn.selected = YES;
        self.addBtn.layer.borderColor = Rgb2UIColor(129, 123, 125, 1).CGColor;
    }
    else{
        _addBtn.selected = NO;
        self.addBtn.layer.borderColor = THEME_COLOR.CGColor;
    }
}

- (void)listenThisVoice{
    NSLog(@"listenThisVoice");
    [self.delegate voiceBtnDelegate:self.voiceURL];
}

@end
