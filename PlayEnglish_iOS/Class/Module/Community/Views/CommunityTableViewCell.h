//
//  CommunityTableViewCell.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 16/10/10.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommunityBtnCellDelegate <NSObject>
-(BOOL)FollowBtnCellDelegate:(NSIndexPath *)index;
-(BOOL)LikeBtnCellDelegate:(NSIndexPath *)index;
-(void)ReplayBtnCellDelegate:(NSIndexPath *)index;
@end

@interface CommunityTableViewCell : UITableViewCell{
    
}

@property (weak, nonatomic) IBOutlet UIView *personalView;
@property (weak, nonatomic) IBOutlet UIImageView *personalHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *personalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *personalCollectBtn;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayImage;

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (nonatomic, strong)id<CommunityBtnCellDelegate> delegate;

@property (nonatomic, copy)NSIndexPath *index;

@property (nonatomic, assign)NSInteger likePerson;

@property (nonatomic, assign)NSInteger commID;

@end
