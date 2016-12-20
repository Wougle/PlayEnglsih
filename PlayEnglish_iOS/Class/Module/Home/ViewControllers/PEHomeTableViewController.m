//
//  PEHomeTableViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 16/9/25.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PEHomeTableViewController.h"
#import "HomeTableViewHeader.h"
#import "HomeCollectionViewCell.h"
#import "HomeTableViewCell.h"
#import "WordLibraryViewController.h"
#import "RlsViewController.h"
#import "PEPersonalTableViewController.h"
#import "PECollectionTableViewController.h"
#import "PEProgressViewController.h"
static NSString *const kHomeCollectionCellIdentity = @"kHomeCollectionCellIdentity";
static NSString *const kHomeHeaderView = @"kHomeHeaderView";
static NSString *const kHomeTableViewCellIdentify = @"kHomeTableViewCellIdentify";

@interface PEHomeTableViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, KDCycleBannerViewDelegate ,KDCycleBannerViewDataource,PYSearchViewControllerDelegate>{
    
    NSArray *_topBannerArray;
    
    NSArray *collectionCellImageArr;
    
    NSArray *collectionCellLabelArr;
    
    NSArray *tableViewCellImageArr;
    
    NSArray *tableViewCellLabelArr;
    
    NSMutableArray *playMutableArr;
    
    NSMutableArray *labelMutableArr;
    
    NSMutableArray *tableMuArr;
    
    CGSize collectionCellSize;

    
}
@property (nonatomic,strong) KDCycleBannerView *topBannerView;

@property (strong, nonatomic) HomeTableViewHeader *homeTableViewHeader;

@property (nonatomic,strong) UIView *headerView;


@end


@implementation PEHomeTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setArray];
    
    [self setPersonData];
    
    [self setRSL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    [self setNavigation];
    
    [self prepareHomeTableViewHeader];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPersonData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HandlerBusiness ServiceWithApicode:ApiCodeGetUserData Parameters:nil Success:^(id data , id msg){
        
        [UserDefaultsUtils saveValue:data[0][@"userID"] forKey:@"userID"];
        [UserDefaultsUtils saveValue:data[0][@"headImage"] forKey:@"headImage"];
        [UserDefaultsUtils saveValue:data[0][@"userName"] forKey:@"nickName"];
        [UserDefaultsUtils saveValue:data[0][@"userSex"] forKey:@"sex"];
        [UserDefaultsUtils saveValue:data[0][@"userAddress"] forKey:@"city"];
        [UserDefaultsUtils saveValue:data[0][@"userPhone"] forKey:@"phone"];
        [UserDefaultsUtils saveValue:data[0][@"userSign"] forKey:@"sign"];
        
    }Failed:^(NSInteger code ,id errorMsg){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }Complete:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)setRSL{
    
    tableMuArr = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HandlerBusiness ServiceWithApicode:ApiCodeGetReadListenSay Parameters:nil Success:^(id data , id msg){
        
        for (int i = 0; i < [data count]; i++) {
            [tableMuArr addObject:data[i]];
        }
        
        [self.tableView reloadData];
        
    }Failed:^(NSInteger code ,id errorMsg){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }Complete:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)setNavigation{
    UIButton *headImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 34.f, 34.f)];
    [headImgBtn setImage:[UIImage imageNamed:[UserDefaultsUtils valueWithKey:@"headImage"]] forState:UIControlStateNormal];
    [headImgBtn addTarget:self action:@selector(headBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:headImgBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 34.f, 34.f)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setArray{
    
    playMutableArr = [[NSMutableArray alloc] init];
    labelMutableArr = [[NSMutableArray alloc] init];
    
    //如果图片地址要改成URL 请去KDCycleBannerView loadData方法里看注释
    _topBannerArray = [NSArray arrayWithObjects:@"the--Youth--Adventure",@"trim",@"the--Youth--Adventure",@"trim",@"the--Youth--Adventure",@"trim", nil];
    collectionCellImageArr = [NSArray arrayWithObjects:@"collection1",@"collection2",@"collection3", nil];
    collectionCellLabelArr = [NSArray arrayWithObjects:@"跟着音乐学英语",@"The BigBang Theory season 9",@"R&B/Hipop\n当节奏蓝调遇上Rap", nil];
    tableViewCellImageArr = [NSArray arrayWithObjects:@"Red",@"trim",@"the--Youth--Adventure",@"She", nil];
    tableViewCellLabelArr = [NSArray arrayWithObjects:@"Taylor Swift\n-----\nRED",@"Taylor Swift\n-----\nRED",@"Taylor Swift\n-----\nRED",@"Taylor Swift\n-----\nRED", nil];
}

- (void)prepareHomeTableViewHeader{
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 481)];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewHeader" owner:self options:nil];
    
    self.homeTableViewHeader = [nib objectAtIndex:0];
    
    self.homeTableViewHeader.frame = CGRectMake(0,0, SCREEN_WIDTH,481);
    
    [self.homeTableViewHeader.favoriteBtn addTarget:self action:@selector(favoriteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.homeTableViewHeader.reviewBtn addTarget:self action:@selector(reviewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.homeTableViewHeader.studyBtn addTarget:self action:@selector(studyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self prepareHomeCollectionView];
    [self prepareTopBannerView];
    
    [self.headerView addSubview:self.homeTableViewHeader];
    
    self.tableView.tableHeaderView = self.headerView;

    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:kHomeTableViewCellIdentify];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)prepareTopBannerView{
    if(self.topBannerView){
        [self.topBannerView removeFromSuperview];
    }
    self.topBannerView = [[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 166)];
    self.topBannerView.delegate   = self;
    self.topBannerView.datasource = self;
    self.topBannerView.autoPlayTimeInterval=3.0f;
    self.topBannerView.continuous=YES;
    [self.topBannerView setBackgroundColor:[UIColor whiteColor]];
    [self.homeTableViewHeader.topBannerView addSubview:self.topBannerView];
}

- (void)prepareHomeCollectionView{
    self.homeTableViewHeader.homeCollectionView.delegate = self;
    self.homeTableViewHeader.homeCollectionView.dataSource = self;
    self.homeTableViewHeader.homeCollectionView.backgroundColor = BG_COLOR;
    [self.homeTableViewHeader.homeCollectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kHomeCollectionCellIdentity];
    
    CGFloat cellWidth = SCREEN_WIDTH*0.33;
    collectionCellSize = CGSizeMake(cellWidth, 185.f);
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
    return collectionCellSize;
}
//定义每个UICollectionView 的边距
-(UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return  1.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  1.0f;
}

#pragma mark UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = [self.homeTableViewHeader.homeCollectionView dequeueReusableCellWithReuseIdentifier:kHomeCollectionCellIdentity forIndexPath:indexPath];
    
    cell.albunImageView.image = [UIImage imageNamed:collectionCellImageArr[indexPath.row]];
    cell.albunLabel.text = collectionCellLabelArr[indexPath.row];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PECollectionTableViewController *vc = [[PECollectionTableViewController alloc] init];
    vc.list = indexPath.row;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableViewCellImageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 184.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeTableViewCellIdentify forIndexPath:indexPath];
    
    cell.playImageView.hidden = NO;
    cell.lyricLabel.text = tableViewCellLabelArr[indexPath.row];
    cell.picturImageView.image = [UIImage imageNamed:tableViewCellImageArr[indexPath.row]];
    cell.lyricLabel.hidden = YES;
    [playMutableArr addObject:cell.playImageView];
    [labelMutableArr addObject:cell.lyricLabel];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    RlsViewController *vc = [[RlsViewController alloc] init];
    vc.videoURL = tableMuArr[indexPath.row][@"mvURL"];
    vc.musicName = tableMuArr[indexPath.row][@"musicName"];
    vc.titleName = tableMuArr[indexPath.row][@"titleName"];
    vc.lookedPerson = tableMuArr[indexPath.row][@"lookedPerson"];
    vc.isLike = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;//    else if (indexPath.row == 1) {
//        self.hidesBottomBarWhenPushed = YES;
//        RlsViewController *vc = [[RlsViewController alloc] init];
//        vc.videoURL = @"http://baobab.wdjcdn.com/14564977406580.mp4";
//        vc.musicName = @"情非得已";
//        vc.titleName = @"庾澄庆-情非得已";
//        vc.imageName = @"trim";
//        vc.lookedPerson = @"999";
//        vc.isLike = NO;
//        [self.navigationController pushViewController:vc animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
//    }
}

//#pragma mark table view delegate
//-(void)DefaultBtnCellDelete:(NSIndexPath *)index{
//    NSLog(@"%ld",(long)index.row);
//    for (int i = 0; i < tableViewCellImageArr.count; i++) {
//        UIImageView *imageView = playMutableArr[i];
//        UILabel *label = labelMutableArr[i];
//        imageView.hidden = NO;
//        label.hidden = YES;
//    }
//    UIImageView *imageView = playMutableArr[index.row];
//    UILabel *label = labelMutableArr[index.row];
//    imageView.hidden = YES;
//    label.hidden = NO;
//}

#pragma mark KDCycleBannerView

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"placeholder"];
}
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index{
    return [UIImage imageNamed:@"placeholder"];
}
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index{
    return UIViewContentModeScaleAspectFit;
}
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView{
    NSMutableArray *banner = [[NSMutableArray alloc] init];
    
    [_topBannerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [banner addObject:obj];
    }];
    return [banner copy];
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index {
//    if(bannerView.tag == 2001){
//        if (![_topBannerURLArray[index]  isEqual: @""]) {
//            HomeWebViewController *vc = [[HomeWebViewController alloc] init];
//            vc.urlStr = _topBannerURLArray[index];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
//    else{
//        if (![_centerBannerURLArray[index]  isEqual: @""]) {
//            HomeWebViewController *vc = [[HomeWebViewController alloc] init];
//            vc.urlStr = _centerBannerURLArray[index];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
}


#pragma mark --ButtonClick

//收藏夹
- (void)favoriteBtnClick{
    WordLibraryViewController *vc = [[WordLibraryViewController alloc] init];
    vc.wordType = 1;
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//复习库
- (void)reviewBtnClick{
    WordLibraryViewController *vc = [[WordLibraryViewController alloc] init];
    vc.wordType = 2;
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//学习进度
- (void)studyBtnClick{
    PEProgressViewController *vc = [[PEProgressViewController alloc] init];
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//头像
- (void)headBtn{
    PEPersonalTableViewController *vc = [[PEPersonalTableViewController alloc] init];
    self.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//搜索
- (void)searchBtn{
    NSArray *hotSeaches = @[@"Red", @"Wanted Dead Or Alive", @"Need You Now", @"Treacherous", @"Show Me", @"If I Knew", @"When I Was Your Man", @"We Are The Champion", @"I'M Not In Love", @"The Lucky One", @"State of Grace", @"Moonshine", @"The Last Time", @"I Kissed A Girl"];
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索热门歌曲" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
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
        
    }];
    // 3. 设置风格
    searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault; // 搜索历史风格为default
    // 4. 设置代理
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    nav.navigationBar.backgroundColor = TEXT_COLOR_THIRDARY;
    [self presentViewController:nav  animated:NO completion:nil];
}

@end
