//
//  PEProgressViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/30.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PEProgressViewController.h"
#import "StudyProgressTableViewCell.h"
#import "RlsViewController.h"
static NSString *const StudyProgressTableViewCellIdentfiy = @"StudyProgressTableViewCellIdentfiy";

@interface PEProgressViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *tableViewCellImageArr;
    
    NSArray *tableViewCellLabelArr;
    
    NSArray *tableViewCellTimeArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PEProgressViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self setData];
    [self setNavigation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_COLOR;
    
    self.tableView.backgroundColor = BG_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}

- (void)setData{
    tableViewCellImageArr = [NSArray arrayWithObjects:@"Red",@"trim",@"She", nil];
    tableViewCellLabelArr = [NSArray arrayWithObjects:@"Taylor Swift\n-----\nRED",@"Taylor Swift\n-----\nRED",@"Ed Sheeran\n-----\nShe", nil];
    tableViewCellTimeArr = [NSArray arrayWithObjects:@"12分钟前", @"57分钟前", @"10小时前", nil];
}

- (void)setNavigation{
    
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 74.f)];
    UIImageView *returnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32, 12, 22)];
    UIImage *returnImage = [UIImage imageNamed:@"left_arrow_black"];
    returnImageView.image = returnImage;
    UILabel *returnBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 32, 100, 22)];
    returnBtnLabel.textColor = TEXT_COLOR_THIRDARY;
    returnBtnLabel.font = [UIFont boldSystemFontOfSize:18];

    returnBtnLabel.text = @"学习进度";

    [self.view addSubview:returnImageView];
    [self.view addSubview:returnBtnLabel];
    [self.view addSubview:returnBtn];
    
    [returnBtn addTarget:self action:@selector(backToView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableViewCellImageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StudyProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StudyProgressTableViewCellIdentfiy];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudyProgressTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.playImage.hidden = YES;
    cell.contentImage.image = [UIImage imageNamed:tableViewCellImageArr[indexPath.row]];
    cell.timeLabel.attributedText = [self setTimeLabel:tableViewCellTimeArr[indexPath.row]];
    cell.contentLabel.text = tableViewCellLabelArr[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.needHideLine.hidden = YES;
    }
    
    if (indexPath.row == 1) {
        cell.contentLabel.hidden = YES;
        cell.playImage.hidden = NO;
    }
    
    return cell;
}

#pragma mark tableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    //设置前几个的背景颜色 并添加一条灰线
    UIView *commonFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0, SCREEN_WIDTH, 50)];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 0, 2.0f, 200.0f)];
    lineView.backgroundColor = Rgb2UIColor(169, 164, 162, 1.0);
    
    [commonFooterView addSubview:lineView];
    
    return commonFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    RlsViewController *vc = [[RlsViewController alloc] init];
    vc.videoURL = @"http://111.1.61.53/he.yinyuetai.com/uploads/videos/common/B8E3013FA9CA150E11046D4FFE109C99.flv?sc=a563e2566d24fdb7";
    vc.musicName = @"Red";
    vc.titleName = @"Taylor Swift—RED";
    vc.imageName = @"rls_picture";
    vc.lookedPerson = @"79";
    vc.isLike = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - setButtonAction
- (void)backToView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableAttributedString *)setTimeLabel:(NSString*)string{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttributes:@{
                             NSFontAttributeName : [UIFont systemFontOfSize:17],
                             NSForegroundColorAttributeName : THEME_COLOR
                             } range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttributes:@{
                             NSFontAttributeName : [UIFont systemFontOfSize:12],
                             NSForegroundColorAttributeName : THEME_COLOR
                             } range:NSMakeRange(2, attrStr.length-2)];
    return attrStr;
}

@end
