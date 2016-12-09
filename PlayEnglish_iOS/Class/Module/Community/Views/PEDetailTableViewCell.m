//
//  PEDetailTableViewCell.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/16.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PEDetailTableViewCell.h"

@implementation PEDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImg.layer.cornerRadius = 14.f;
    _headImg.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
