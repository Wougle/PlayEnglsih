//
//  WordLibraryCollectionViewCell.m
//  PlayEnglish_iOS
//
//  Created by KentonYu on 16/10/15.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "WordLibraryCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
@implementation WordLibraryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.cardView.layer.cornerRadius = 2.f;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOffset=CGSizeMake(3, 3);
    self.cardView.layer.shadowOpacity=0.2;
    self.cardView.layer.shadowRadius=1;
    
    [self.AmericanEnglishBtn addTarget:self action:@selector(American) forControlEvents:UIControlEventTouchUpInside];
    [self.BritishEnglishBtn addTarget:self action:@selector(British) forControlEvents:UIControlEventTouchUpInside];
}

- (void)American{
    [self.delegate AmericanCellDelegate:self.index withVideoName:self.videoName];
}

- (void)British{
    [self.delegate BritishBtnCellDelegate:self.index withVideoName:self.videoName];
}

@end
