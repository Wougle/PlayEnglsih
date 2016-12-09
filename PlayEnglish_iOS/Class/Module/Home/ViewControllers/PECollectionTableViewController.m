//
//  PECollectionTableViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/23.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PECollectionTableViewController.h"
#import "CollectionTableViewCell.h"
#import "RlsViewController.h"
// 宏定义一个高度
#define pictureHeight 200
static NSString *const kCollectionTableViewCellIdentify = @"kCollectionTableViewCellIdentify";
@interface PECollectionTableViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *tableMuArr;
}
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIView *header;

@end

@implementation PECollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    self.navigationItem.title = @"热门收藏";
    // 下面两个属性的设置是与translucent为NO,坐标变换的效果一样
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createTableView];
    
    
}

- (void)loadData{

    tableMuArr = [[NSMutableArray alloc] init];
    NSDictionary *tableDic1 = [[NSDictionary alloc] init];
    NSDictionary *tableDic2 = [[NSDictionary alloc] init];
    NSDictionary *tableDic3 = [[NSDictionary alloc] init];
    NSDictionary *tableDic4 = [[NSDictionary alloc] init];
    NSDictionary *tableDic5 = [[NSDictionary alloc] init];
    NSDictionary *tableDic6 = [[NSDictionary alloc] init];
    NSDictionary *tableDic7 = [[NSDictionary alloc] init];

    
    if (self.type == 0) {
        tableDic1 = @{
                      @"name":@"Taylor Swift",
                      @"song":@"Red",
                      };
        
        tableDic2 = @{
                      @"name":@"Taylor Swift",
                      @"song":@"State of Grace 恩宠状态",
                      };
        
        tableDic3 = @{
                      @"name":@"Taylor Swift / Dan Wilson",
                      @"song":@"Treacherous 危险关系",
                      };
        
        tableDic4 = @{
                      @"name":@"Taylor Swift / Gary Litery",
                      @"song":@"The Last Time 最后一刻",
                      };
        
        tableDic5 = @{
                      @"name":@"Taylor Swift / Marx Martin",
                      @"song":@"We Are Never Ever Get Back Together",
                      };
        
        tableDic6 = @{
                      @"name":@"Taylor Swift",
                      @"song":@"All Too Well 回忆太清晰",
                      };
        
        tableDic7 = @{
                      @"name":@"Taylor Swift",
                      @"song":@"The Lucky One 幸运儿",
                      };
    }
    else if (self.type == 1){
        tableDic1 = @{
                      @"name":@"Tony Christie",
                      @"song":@"I'M Not In Love",
                      };
        
        tableDic2 = @{
                      @"name":@"P!nk",
                      @"song":@"Get The Party Started",
                      };
        
        tableDic3 = @{
                      @"name":@"Katy Perry",
                      @"song":@"I Kissed A Girl",
                      };
        
        tableDic4 = @{
                      @"name":@"Queen",
                      @"song":@"We Are The Champion",
                      };
        
        tableDic5 = @{
                      @"name":@"Lady Antebellum",
                      @"song":@"Need You Now",
                      };
        
        tableDic6 = @{
                      @"name":@"Bon Jovi",
                      @"song":@"Wanted Dead Or Alive",
                      };
        tableDic7 = @{
                      @"name":@"Taylor Swift",
                      @"song":@"The Lucky One",
                      };
    }
    else{
        tableDic1 = @{
                      @"name":@"Bruno Mars / PhilipLawrence",
                      @"song":@"Show Me",
                      };
        
        tableDic2 = @{
                      @"name":@"Bruno Mars",
                      @"song":@"Money Make Her Smile",
                      };
        
        tableDic3 = @{
                      @"name":@"Bruno Mars / Ari Levine",
                      @"song":@"If I Knew",
                      };
        
        tableDic4 = @{
                      @"name":@"Bruno Mars / Jeff Bhasker",
                      @"song":@"Locked Out of Heaven",
                      };
        
        tableDic5 = @{
                      @"name":@"Bruno Mars",
                      @"song":@"Moonshine",
                      };
        
        tableDic6 = @{
                      @"name":@"Bruno Mars",
                      @"song":@"When I Was Your Man",
                      };
        tableDic7 = @{
                      @"name":@"Bruno Mars / Ari Levine",
                      @"song":@"The Lucky One",
                      };
    }
    
    
    [tableMuArr addObject:tableDic1];
    [tableMuArr addObject:tableDic2];
    [tableMuArr addObject:tableDic3];
    [tableMuArr addObject:tableDic4];
    [tableMuArr addObject:tableDic5];
    [tableMuArr addObject:tableDic6];
    [tableMuArr addObject:tableDic7];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 添加头视图 在头视图上添加ImageView
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, pictureHeight)];
    _pictureImageView = [[UIImageView alloc] initWithFrame:_header.bounds];
    _pictureImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"collection%ld",self.type+1]];
    /*
     重要的属性设置
     */
    //这个属性的值决定了 当视图的几何形状变化时如何复用它的内容 这里用 UIViewContentModeScaleAspectFill 意思是保持内容高宽比 缩放内容 超出视图的部分内容会被裁减 填充UIView
    _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    // 这个属性决定了子视图的显示范围 取值为YES时，剪裁超出父视图范围的子视图部分.这里就是裁剪了_pictureImageView超出_header范围的部分.
    _pictureImageView.clipsToBounds = YES;
    [_header addSubview:_pictureImageView];
    self.tableView.tableHeaderView = _header;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = Rgb2UIColor(245, 245, 245, 1.f);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return tableMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectionTableViewCellIdentify];
    if (!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"CollectionTableViewCell" owner:self options:nil
                ][0];
    }
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.songLabel.text = tableMuArr[indexPath.row][@"song"];
    cell.nameLabel.text = tableMuArr[indexPath.row][@"name"];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    /**
     *  这里的偏移量是纵向从contentInset算起 则一开始偏移就是0 向下为负 上为正 下拉
     */
    
    // 获取到tableView偏移量
    CGFloat Offset_y = scrollView.contentOffset.y;
    // 下拉 纵向偏移量变小 变成负的
    if ( Offset_y < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = pictureHeight - Offset_y;
        // 图片放大比例
        CGFloat scale = totalOffset / pictureHeight;
        CGFloat width = SCREEN_WIDTH;
        // 拉伸后图片位置
        _pictureImageView.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
    }
    
}

@end
