//
//  CommunityTableViewCell.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 16/10/10.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "CommunityTableViewCell.h"

@implementation CommunityTableViewCell{
    BOOL followFlag;
    BOOL followR;
    BOOL likeFlag;
    BOOL likeR;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    followR = 0;
    likeR = 0;
    _personalHeadImgView.layer.cornerRadius = 20.f;
    _personalHeadImgView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)followAction:(id)sender {
    if (followR == 0) {
        followFlag = [self.delegate FollowBtnCellDelegate:self.index];
        followR = 1;
    }
    
    if (followFlag == 0) {
        [self.personalCollectBtn setSelected:YES];
        followFlag = 1;
    }
    else{
        [self.personalCollectBtn setSelected:NO];
        followFlag = 0;
    }
}

- (IBAction)replyAction:(id)sender {
    [self.delegate ReplayBtnCellDelegate:self.index];
}

- (IBAction)likeAction:(id)sender {
    if (likeR == 0) {
        likeFlag = [self.delegate LikeBtnCellDelegate:self.index];
        likeR = 1;
    }

    if (likeFlag == 0) {
        self.likePerson +=1;
        [self.likeBtn setSelected:YES];
        likeFlag = 1;
        [_likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.likePerson] forState:UIControlStateNormal];
    }
    else{
        self.likePerson -=1;
        [self.likeBtn setSelected:NO];
        likeFlag = 0;
        [_likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.likePerson] forState:UIControlStateNormal];
    }
}

@end
