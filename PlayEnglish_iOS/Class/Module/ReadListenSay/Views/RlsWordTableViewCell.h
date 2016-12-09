//
//  RlsWordTableViewCell.h
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/10/20.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RlsWordTableViewCellDelegate<NSObject>
- (void)voiceBtnDelegate:(NSString *)str;
@end

@interface RlsWordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronounceLabel;
@property (weak, nonatomic) IBOutlet UILabel *meansLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong) NSString *voiceURL;//音频地址
@property (strong, nonatomic) id<RlsWordTableViewCellDelegate> delegate;

@end
