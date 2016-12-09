//
//  PESettingTableViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/27.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PESettingTableViewController.h"
#import "PESettingTableViewCell.h"

static NSString *const PESettingTableViewCellIdentify = @"PESettingTableViewCellIdentify";
@interface PESettingTableViewController (){
    NSArray *titleArr;
}

@end

@implementation PESettingTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    titleArr = @[@"账户与安全",@"新消息通知",@"隐私",@"通用",@"帮助与反馈",@"关于我们"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的设置";
    self.tableView.backgroundColor = Rgb2UIColor(243, 243, 243, 1.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 3;
    }
    else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PESettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PESettingTableViewCellIdentify];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"PESettingTableViewCell" owner:self options:nil][0];
    }
    
    cell.setLabel.text = titleArr[indexPath.section*indexPath.section + indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 15.0f;
    }
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

@end
