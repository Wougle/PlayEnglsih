//
//  PECommunityTableViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 16/9/25.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PECommunityTableViewController.h"
#import "CommunityTableViewCell.h"
#import "PEPersonalTableViewController.h"
#import "PEDetailViewController.h"
#import "RlsViewController.h"
#import "PESubmitViewController.h"
static NSString *const kCommunityTableViewCellIdentify = @"kCommunityTableViewCellIdentify";

@interface PECommunityTableViewController ()<UITableViewDelegate,UITableViewDataSource,CommunityBtnCellDelegate,PYSearchViewControllerDelegate>
{
    NSMutableArray *tableMuArr;
    NSMutableArray *cellHeightArr;
}
@end

@implementation PECommunityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"社区";
    
    [self setData];
    
    [self setNavigation];
    
    [self setTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTable{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommunityTableViewCell" bundle:nil] forCellReuseIdentifier:kCommunityTableViewCellIdentify];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = Rgb2UIColor(245, 245, 245, 1.f);
    
}

- (void)setData{
    cellHeightArr = [[NSMutableArray alloc] init];
    tableMuArr = [[NSMutableArray alloc] init];
    NSDictionary *tableDic1 = [[NSDictionary alloc] init];
    NSDictionary *tableDic2 = [[NSDictionary alloc] init];
    NSDictionary *tableDic3 = [[NSDictionary alloc] init];
    NSDictionary *tableDic4 = [[NSDictionary alloc] init];
    NSDictionary *tableDic5 = [[NSDictionary alloc] init];
    NSDictionary *tableDic6 = [[NSDictionary alloc] init];

    tableDic1 = @{
                 @"headImg":@"headImage1",
                 @"name":@"张小明",
                 @"time":@"12-1 14:49",
                 @"isFollow":@"1",
                 @"text":@"学好英文必须静下心来，日积月累，切不可急功近利。从一词一句开始积累，多听、多说、多读，长年坚持，必有收获。因为学习外语的时间和对其掌握的熟练程度成正比，也可以说任何一门外语听说读写译的熟练运用都是工夫堆积起来的。英语中有个谚语：Rome was not built in a day.说的就是这个道理。",
                 @"image":@"-1",
                 @"video":@"-1",
                 @"reply":@"8",
                 @"like":@"9",
                 @"isLike":@"1",
                 };
    
    tableDic2 = @{
                  @"headImg":@"headImage2",
                  @"name":@"金菲菲",
                  @"time":@"11-11 7:32",
                  @"isFollow":@"0",
                  @"text":@"If not to the sun for smiling, warm is still in the sun there, but wewill laugh more confident calm; if turned to found his own shadow, appropriate escape, the sun will be through the heart,warm each place behind the corner; if an outstretched palm cannot fall butterfly, then clenched waving arms, given power; if I can't have bright smile, it will face to the sunshine, and sunshine smile together, in full bloom.",
                  @"image":@"communityPic2",
                  @"video":@"-1",
                  @"reply":@"14",
                  @"like":@"6",
                  @"isLike":@"0",
                 };
    
    tableDic3 = @{
                 @"headImg":@"headImage3",
                 @"name":@"林琳琳",
                 @"time":@"11-2 15:01",
                 @"isFollow":@"1",
                 @"text":@"推荐这个视频，语速不快，吐字清晰，有字幕。",
                 @"image":@"-1",
                 @"video":@"trim",
                 @"reply":@"32",
                 @"like":@"17",
                 @"isLike":@"0",
                 };
    
    tableDic4 = @{
                  @"headImg":@"headImage4",
                  @"name":@"李名名",
                  @"time":@"10-13 20:11",
                  @"isFollow":@"0",
                  @"text":@"英语口语怎么练？",
                  @"image":@"communityPic",
                  @"video":@"-1",
                  @"reply":@"11",
                  @"like":@"2",
                  @"isLike":@"1",
                  };
    
    tableDic5 = @{
                  @"headImg":@"headImage5",
                  @"name":@"刘可可",
                  @"time":@"10-7 13:55",
                  @"isFollow":@"1",
                  @"text":@"好想快速提高英语口语啊TAT",
                  @"image":@"communityPic3",
                  @"video":@"-1",
                  @"reply":@"8",
                  @"like":@"22",
                  @"isLike":@"1",
                  };
    
    tableDic6 = @{
                  @"headImg":@"headImage6",
                  @"name":@"王东东",
                  @"time":@"9-17 9:41",
                  @"isFollow":@"1",
                  @"text":@"时而压抑、时而诙谐、人物性格刻划得鲜明，只是觉得剧情不是那么贴近生活，不过里面的句子还有哲理性，几个主演的英语也是非常标准，是一部学习英语值得推崇的super soup。",
                  @"image":@"-1",
                  @"video":@"She",
                  @"reply":@"19",
                  @"like":@"31",
                  @"isLike":@"0",
                  };

    
    [tableMuArr addObject:tableDic1];
    [tableMuArr addObject:tableDic2];
    [tableMuArr addObject:tableDic3];
    [tableMuArr addObject:tableDic4];
    [tableMuArr addObject:tableDic5];
    [tableMuArr addObject:tableDic6];
}

#pragma mark - Navigation
- (void)setNavigation{
    UIButton *headImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 34.f, 34.f)];
    [headImgBtn setImage:[UIImage imageNamed:[UserDefaultsUtils valueWithKey:@"headImage"]] forState:UIControlStateNormal];
    [headImgBtn addTarget:self action:@selector(headBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:headImgBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
    [addBtn setImage:[UIImage imageNamed:@"发帖"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return tableMuArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityTableViewCellIdentify];
    if (!cell) {
        cell=[[NSBundle mainBundle]loadNibNamed:@"CommunityTableViewCell" owner:self options:nil][0];
    }
    cell.delegate = self;
    cell.index = indexPath;
    CGFloat height;
    height = 101;
    
    cell.personalHeadImgView.image = [UIImage imageNamed:tableMuArr[indexPath.row][@"headImg"]];
    cell.personalNameLabel.text = tableMuArr[indexPath.row][@"name"];
    cell.personalTimeLabel.text = tableMuArr[indexPath.row][@"time"];
    
    if ([tableMuArr[indexPath.row][@"isFollow"]  isEqual: @"0"]) {
        [cell.personalCollectBtn setSelected:NO];
    }
    else{
        [cell.personalCollectBtn setSelected:YES];
    }
    
    if ([tableMuArr[indexPath.row][@"text"]  isEqual: @"-1"]) {
        cell.detailView.hidden = YES;
    }
    else{
        cell.detailView.width = SCREEN_WIDTH;
        cell.detailLabel.width = SCREEN_WIDTH;
        cell.detailLabel.text = tableMuArr[indexPath.row][@"text"];
        cell.detailLabel.numberOfLines = 0;
        [cell.detailLabel sizeToFit];
        cell.detailView.height = cell.detailLabel.frame.size.height;
        height += cell.detailLabel.frame.size.height + 20;
        if (indexPath.row < 2) {
            height += 20;
        }
    }
    
    if ([tableMuArr[indexPath.row][@"image"]  isEqual: @"-1"]) {
        cell.pictureView.hidden = YES;
    }
    else{
        cell.pictureView.hidden = NO;
        cell.pictureImage.image = [UIImage imageNamed:tableMuArr[indexPath.row][@"image"]];
        height += 150;
    }
    
    if ([tableMuArr[indexPath.row][@"video"]  isEqual: @"-1"]) {
        cell.videoView.hidden = YES;
    }
    else{
        cell.videoView.hidden = NO;
        cell.videoImage.image = [UIImage imageNamed:tableMuArr[indexPath.row][@"video"]];
        height += 205;
    }
    
    [cell.replyBtn setTitle:tableMuArr[indexPath.row][@"reply"] forState:UIControlStateNormal];
    
    if ([tableMuArr[indexPath.row][@"isLike"]  isEqual: @"0"]) {
        [cell.likeBtn setSelected:NO];
    }
    else{
        [cell.likeBtn setSelected:YES];
    }
    [cell.likeBtn setTitle:tableMuArr[indexPath.row][@"like"] forState:UIControlStateNormal];
    cell.likePerson = [tableMuArr[indexPath.row][@"like"] integerValue];
    CGRect labelRect = cell.frame;
    labelRect.size.height = height;
    cell.frame = labelRect;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommunityTableViewCell *cell=(CommunityTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PEDetailViewController *vc = [[PEDetailViewController alloc] init];
    vc.number = indexPath.row;
    vc.isReply = 0;
    vc.viewType = 1;
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed  = NO;
}

#pragma mark CommunityBtnCellDelegate

- (BOOL)FollowBtnCellDelegate:(NSIndexPath *)index{
    return [tableMuArr[index.row][@"isFollow"] boolValue];
}

-(BOOL)LikeBtnCellDelegate:(NSIndexPath *)index{
    return [tableMuArr[index.row][@"isLike"] boolValue];
}

- (void)ReplayBtnCellDelegate:(NSIndexPath *)index{
    PEDetailViewController *vc = [[PEDetailViewController alloc] init];
    vc.number = index.row;
    vc.isReply = 1;
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed  = NO;
}

#pragma mark --ButtonClick

//头像
- (void)headBtn{
    PEPersonalTableViewController *vc = [[PEPersonalTableViewController alloc] init];
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//发表
- (void)addBtn{
    PESubmitViewController *vc = [[PESubmitViewController alloc] init];
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
