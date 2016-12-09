//
//  HomeTableViewHeader.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 16/9/25.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewHeader : UIView
@property (weak, nonatomic) IBOutlet UIView *topBannerView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *studyBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *homeCollectionView;

@end
