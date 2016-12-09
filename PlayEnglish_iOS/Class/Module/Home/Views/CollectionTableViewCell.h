//
//  CollectionTableViewCell.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/23.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@end
