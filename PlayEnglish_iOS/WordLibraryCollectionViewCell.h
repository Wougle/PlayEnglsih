//
//  WordLibraryCollectionViewCell.h
//  PlayEnglish_iOS
//
//  Created by KentonYu on 16/10/15.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PronounceBtnCellDelegate <NSObject>
-(void)BritishBtnCellDelegate:(NSIndexPath *)index withVideoName:(NSString *)videoName;
-(void)AmericanCellDelegate:(NSIndexPath *)index withVideoName:(NSString *)videoName;

@end

@interface WordLibraryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UILabel *singleWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *BritishEnglishBtn;
@property (weak, nonatomic) IBOutlet UIButton *AmericanEnglishBtn;
@property (weak, nonatomic) IBOutlet UILabel *EnglishPronounceLabel;
@property (weak, nonatomic) IBOutlet UILabel *AmericanPronounceLabel;
@property (weak, nonatomic) IBOutlet UILabel *WordMeaningLabel;

@property (nonatomic ,strong)id<PronounceBtnCellDelegate> delegate;

@property (nonatomic,copy)NSIndexPath *index;
@property (nonatomic,copy)NSString *videoName;

@end
