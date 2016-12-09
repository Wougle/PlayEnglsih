//
//  CollectionTableViewCell.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/23.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "CollectionTableViewCell.h"

@implementation CollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.playImage.layer.cornerRadius = 3.0f;
    self.playImage.layer.masksToBounds = YES;
    self.playImage.layer.borderColor = LINE_COLOR.CGColor;
    self.playImage.layer.borderWidth = 2.0f;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
