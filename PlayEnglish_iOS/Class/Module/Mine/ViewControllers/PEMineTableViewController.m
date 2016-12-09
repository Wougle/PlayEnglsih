//
//  PEMineTableViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/12.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PEMineTableViewController.h"
#import "personalCenterHeadView.h"
#import "PersonalCenterTableViewCell.h"
#import "WordLibraryViewController.h"
#import "PESettingTableViewController.h"
#import "PEProgressViewController.h"
#import "PEMyLikeCommTableViewController.h"
static NSString *const kPersonalCenterTableViewCell = @"kPersonalCenterTableViewCell";
@interface PEMineTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *iconArr;
    NSArray *titleArr;
}

@property (strong, nonatomic) personalCenterHeadView *personalCenterHeadView;

@end

@implementation PEMineTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    iconArr = @[@"收藏",@"学习",@"进度时间",@"关注",@"设置",];
    titleArr = @[@"收藏夹",@"复习库",@"学习进度",@"我的关注",@"我的设置"];
    [self prepareView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的主页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareView{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = Rgb2UIColor(243, 243, 243, 1.0);
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"personalCenterHeadView" owner:self options:nil];
    self.personalCenterHeadView = [nib objectAtIndex:0];
    self.personalCenterHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    self.personalCenterHeadView.headImage.image = [UIImage imageNamed:[UserDefaultsUtils valueWithKey:@"headImage"]];
    self.personalCenterHeadView.nickNameLabel.text = [UserDefaultsUtils valueWithKey:@"nickName"];
    
    self.tableView.tableHeaderView = self.personalCenterHeadView;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = Rgb2UIColor(243, 243, 243, 1.0);
    self.tableView.tableFooterView =view;
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    else if(section == 1){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30.0f;
    }
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonalCenterTableViewCell];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalCenterTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 1) {
        cell.iconImg.image = [UIImage imageNamed:iconArr[4]];
        cell.titleLabel.text = titleArr[4];
    }
    else{
        cell.iconImg.image = [UIImage imageNamed:iconArr[indexPath.row]];
        cell.titleLabel.text = titleArr[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            WordLibraryViewController *vc = [[WordLibraryViewController alloc] init];
            vc.wordType = 1;
            self.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        else if (indexPath.row == 1){
            WordLibraryViewController *vc = [[WordLibraryViewController alloc] init];
            vc.wordType = 2;
            self.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        else if (indexPath.row == 2){
            PEProgressViewController *vc = [[PEProgressViewController alloc] init];
            self.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        else {
            PEMyLikeCommTableViewController *vc = [[PEMyLikeCommTableViewController alloc] init];
            self.hidesBottomBarWhenPushed  = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }
    else{
        PESettingTableViewController *vc = [[PESettingTableViewController alloc] init];
        self.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end
