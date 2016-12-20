//
//  PEDetailViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/25.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PEDetailViewController.h"
#import "CommunityTableViewCell.h"
#import "PEDetailTableViewCell.h"
static NSString *const kPEDetailTableViewCell = @"kPEDetailTableViewCeell";
static NSString *const kCommunityTableViewCellIdentify = @"kCommunityTableViewCellIdentify";
static CGFloat TextViewFontSize=14;

@interface PEDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CommunityBtnCellDelegate, UITextViewDelegate>{
    NSMutableArray *tableMuArr;
    NSMutableArray *speakMuArr;
    NSMutableArray *cellHeightArr;
    NSString *commentString;
    int kHeight;
    UITapGestureRecognizer* singleTap;
    UIButton *sendBtn;
    UIView *baView;
    UIView *messageView;
    NSTimer *countDownTimer;
    int replyIdLocal;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *baView;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewH;

@end

@implementation PEDetailViewController

@synthesize messageView = _messageView;
@synthesize sendBtn = _sendBtn;
@synthesize baView = _baView;


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self setTable];
    [self setData];
    [self setSendMessageView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HandlerBusiness ServiceWithApicode:ApiCodeGetCommunityList Parameters:nil Success:^(id data , id msg){
        DBG(@"111");
    }Failed:^(NSInteger code ,id errorMsg){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }Complete:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:countDownTimer forMode:NSRunLoopCommonModes];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_messageField resignFirstResponder];
    
    [IQKeyboardManager sharedManager].enable = YES;
}

//倒计时
-(void)timeFireMethod{
    if (self.isReply == 1) {
        [_messageField becomeFirstResponder];
    }
    [countDownTimer invalidate];
}

        

- (void)setTable{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommunityTableViewCell" bundle:nil] forCellReuseIdentifier:kCommunityTableViewCellIdentify];
    [self.tableView registerNib:[UINib nibWithNibName:@"PEDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kPEDetailTableViewCell];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = NO;
    self.tableView.backgroundColor = Rgb2UIColor(245, 245, 245, 1.f);
}

-(void)setSendMessageView{
    self.messageView.layer.cornerRadius=15;
    self.messageView.layer.borderColor=LINE_COLOR.CGColor;
    self.messageView.layer.borderWidth=1;
    _messageField.showsVerticalScrollIndicator=NO;
    _messageField.delegate = self;
    //_messageField.placeholder=@"输入评论";
    _messageField.clipsToBounds=YES;
    _messageField.bounces=NO;
    [self.sendBtn addTarget:self action:@selector(sendTopicComment) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sendTopicComment{
    [self.view endEditing:YES];
    
    NSDictionary *tableDic = [[NSMutableDictionary alloc] init];
    
    

    NSDate *detaildate=[NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *timeString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: detaildate]];
    commentString=_messageField.text;
    _messageField.text = nil;
    replyIdLocal = replyIdLocal +1;
    tableDic = @{
                  @"replyID":[NSString stringWithFormat:@"%d",replyIdLocal],
                  @"headImage":[UserDefaultsUtils valueWithKey:@"headImage"],
                  @"nickName":[UserDefaultsUtils valueWithKey:@"nickName"],
                  @"time":timeString,
                  @"text":commentString,
                  @"like":@"0",
                  @"isLike":@"1",
                  };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HandlerBusiness ServiceWithApicode:ApiCodeSubmitReplyList Parameters:tableDic Success:^(id data , id msg){
        DBG(@"发表成功");
        
    }Failed:^(NSInteger code ,id errorMsg){
        [CustomHUD createShowContent:@"发表评论成功" hiddenTime:2 ];
        

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }Complete:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    
    [speakMuArr addObject:tableDic];
    [self.tableView reloadData];
    [self handleSingleTap];
    DBG(@"发评论");
}

-(void)handleSingleTap{
    [_messageField resignFirstResponder];
    [self textViewDidEndEditing:_messageField];
}

//以下两个代理方法可以防止键盘遮挡textview

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self.view addGestureRecognizer:singleTap];
    
    float offset = 0.0f;
    
    if(_messageField == textView){
        
        offset = -kHeight;
        
    }
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    commentString=textView.text;
    
    [self.view removeGestureRecognizer:singleTap];
    
    float offset = 0.0f;
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark - textView delegate
-(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font width:(float)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width,   800) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}
-(void)textViewDidChange:(UITextView *)textView{
    //该判断用于联想输入
    if (textView.text.length > 200)
    {
        textView.text = [textView.text substringToIndex:200];
        return;
    }
    //textView高度变化
    CGSize size;
    
    //获取文本中字体的size
    size = [self sizeWithString:textView.text font:[UIFont systemFontOfSize:TextViewFontSize] width:textView.width-10];
    //获取一行的高度
    CGSize size1 = [self sizeWithString:@"Hello" font:[UIFont systemFontOfSize:TextViewFontSize] width:textView.width-10];
    NSInteger i = size.height/size1.height;
    if(i>=4){//超过(x-1)行不变高
        _messageField.scrollEnabled=YES ;
        return;
    }else
        if (self.number!=i) {
            self.number = i;
            _textViewH.constant = (i==1?30:size.height+18);//一行固定高度
            _messageField.contentSize=_messageField.size;
        }
}


-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary*info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSLog(@"keyboard changed, keyboard width = %f, height = %f",
          kbSize.width,kbSize.height);
    kHeight = kbSize.height;
    [self textViewDidBeginEditing:_messageField];
    //在这里调整UI位置
}


- (void)setData{
    cellHeightArr = [[NSMutableArray alloc] init];
    tableMuArr = [[NSMutableArray alloc] init];
    speakMuArr = [[NSMutableArray alloc] init];
    
//    NSDictionary *tableDic1 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic2 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic3 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic4 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic5 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic6 = [[NSDictionary alloc] init];
//    
//    if (self.viewType == 2){
//        tableDic1 = @{
//                      @"headImg":@"headImage1",
//                      @"name":@"张小明",
//                      @"time":@"12-1 14:49",
//                      @"isFollow":@"1",
//                      @"text":@"学好英文必须静下心来，日积月累，切不可急功近利。从一词一句开始积累，多听、多说、多读，长年坚持，必有收获。因为学习外语的时间和对其掌握的熟练程度成正比，也可以说任何一门外语听说读写译的熟练运用都是工夫堆积起来的。英语中有个谚语：Rome was not built in a day.说的就是这个道理。",
//                      @"image":@"-1",
//                      @"video":@"-1",
//                      @"reply":@"8",
//                      @"like":@"9",
//                      @"isLike":@"1",
//                      };
//        
//        tableDic3 = @{
//                      @"headImg":@"headImage3",
//                      @"name":@"林琳琳",
//                      @"time":@"11-2 15:01",
//                      @"isFollow":@"1",
//                      @"text":@"推荐这个视频，语速不快，吐字清晰，有字幕。",
//                      @"image":@"-1",
//                      @"video":@"trim",
//                      @"reply":@"32",
//                      @"like":@"17",
//                      @"isLike":@"0",
//                      };
//        
//        tableDic5 = @{
//                      @"headImg":@"headImage5",
//                      @"name":@"刘可可",
//                      @"time":@"10-7 13:55",
//                      @"isFollow":@"1",
//                      @"text":@"好想快速提高英语口语啊TAT",
//                      @"image":@"communityPic3",
//                      @"video":@"-1",
//                      @"reply":@"8",
//                      @"like":@"22",
//                      @"isLike":@"1",
//                      };
//        
//        tableDic6 = @{
//                      @"headImg":@"headImage6",
//                      @"name":@"王东东",
//                      @"time":@"9-17 9:41",
//                      @"isFollow":@"1",
//                      @"text":@"时而压抑、时而诙谐、人物性格刻划得鲜明，只是觉得剧情不是那么贴近生活，不过里面的句子还有哲理性，几个主演的英语也是非常标准，是一部学习英语值得推崇的super soup。",
//                      @"image":@"-1",
//                      @"video":@"She",
//                      @"reply":@"19",
//                      @"like":@"31",
//                      @"isLike":@"0",
//                      };
//        
//        
//        [tableMuArr addObject:tableDic1];
//        [tableMuArr addObject:tableDic3];
//        [tableMuArr addObject:tableDic5];
//        [tableMuArr addObject:tableDic6];
//    }
//    else{
//        tableDic1 = @{
//                      @"headImg":@"headImage1",
//                      @"name":@"张小明",
//                      @"time":@"12-1 14:49",
//                      @"isFollow":@"1",
//                      @"text":@"学好英文必须静下心来，日积月累，切不可急功近利。从一词一句开始积累，多听、多说、多读，长年坚持，必有收获。因为学习外语的时间和对其掌握的熟练程度成正比，也可以说任何一门外语听说读写译的熟练运用都是工夫堆积起来的。英语中有个谚语：Rome was not built in a day.说的就是这个道理。",
//                      @"image":@"-1",
//                      @"video":@"-1",
//                      @"reply":@"8",
//                      @"like":@"9",
//                      @"isLike":@"1",
//                      };
//        
//        tableDic2 = @{
//                      @"headImg":@"headImage2",
//                      @"name":@"金菲菲",
//                      @"time":@"11-11 7:32",
//                      @"isFollow":@"0",
//                      @"text":@"If not to the sun for smiling, warm is still in the sun there, but wewill laugh more confident calm; if turned to found his own shadow, appropriate escape, the sun will be through the heart,warm each place behind the corner; if an outstretched palm cannot fall butterfly, then clenched waving arms, given power; if I can't have bright smile, it will face to the sunshine, and sunshine smile together, in full bloom.",
//                      @"image":@"communityPic2",
//                      @"video":@"-1",
//                      @"reply":@"14",
//                      @"like":@"6",
//                      @"isLike":@"0",
//                      };
//        
//        tableDic3 = @{
//                      @"headImg":@"headImage3",
//                      @"name":@"林琳琳",
//                      @"time":@"11-2 15:01",
//                      @"isFollow":@"1",
//                      @"text":@"推荐这个视频，语速不快，吐字清晰，有字幕。",
//                      @"image":@"-1",
//                      @"video":@"trim",
//                      @"reply":@"32",
//                      @"like":@"17",
//                      @"isLike":@"0",
//                      };
//        
//        tableDic4 = @{
//                      @"headImg":@"headImage4",
//                      @"name":@"李名名",
//                      @"time":@"10-13 20:11",
//                      @"isFollow":@"0",
//                      @"text":@"英语口语怎么练？",
//                      @"image":@"communityPic",
//                      @"video":@"-1",
//                      @"reply":@"11",
//                      @"like":@"2",
//                      @"isLike":@"1",
//                      };
//        
//        tableDic5 = @{
//                      @"headImg":@"headImage5",
//                      @"name":@"刘可可",
//                      @"time":@"10-7 13:55",
//                      @"isFollow":@"1",
//                      @"text":@"好想快速提高英语口语啊TAT",
//                      @"image":@"communityPic3",
//                      @"video":@"-1",
//                      @"reply":@"8",
//                      @"like":@"22",
//                      @"isLike":@"1",
//                      };
//        
//        tableDic6 = @{
//                      @"headImg":@"headImage6",
//                      @"name":@"王东东",
//                      @"time":@"9-17 9:41",
//                      @"isFollow":@"1",
//                      @"text":@"时而压抑、时而诙谐、人物性格刻划得鲜明，只是觉得剧情不是那么贴近生活，不过里面的句子还有哲理性，几个主演的英语也是非常标准，是一部学习英语值得推崇的super soup。",
//                      @"image":@"-1",
//                      @"video":@"She",
//                      @"reply":@"19",
//                      @"like":@"31",
//                      @"isLike":@"0",
//                      };
//        
//        [tableMuArr addObject:tableDic1];
//        [tableMuArr addObject:tableDic2];
//        [tableMuArr addObject:tableDic3];
//        [tableMuArr addObject:tableDic4];
//        [tableMuArr addObject:tableDic5];
//        [tableMuArr addObject:tableDic6];
//    }

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HandlerBusiness ServiceWithApicode:ApiCodeGetReplyList Parameters:nil Success:^(id data , id msg){
        replyIdLocal = (int)[data count];
        for (int i = 0; i < [data count]; i++) {
            [speakMuArr addObject:data[i]];
        }
        
        [self.tableView reloadData];
        
    }Failed:^(NSInteger code ,id errorMsg){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }Complete:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
//    NSDictionary *speakDic1 = [[NSDictionary alloc] init];
//    NSDictionary *speakDic2 = [[NSDictionary alloc] init];
//    NSDictionary *speakDic3 = [[NSDictionary alloc] init];
//    NSDictionary *speakDic4 = [[NSDictionary alloc] init];
//    NSDictionary *speakDic5 = [[NSDictionary alloc] init];
//    NSDictionary *speakDic6 = [[NSDictionary alloc] init];
//    
//    speakDic1 = @{
//                  @"headImg":@"headImage5",
//                  @"name":@"郑甜甜",
//                  @"time":@"11-30 17:51",
//                  @"text":@"Life is full of confusing and disordering Particular time,a particular location,Do the arranged thing of ten million time in the brain,Step by step ,the life is hard to avoid delicacy and stiffness No enthusiasm forever,No unexpected happening of surprising and pleasing So,only silently ask myself in mind Next happiness,when will come?",
//                  @"like":@"17",
//                  @"isLike":@"0",
//                  };
//    
//    speakDic2 = @{
//                  @"headImg":@"headImage2",
//                  @"name":@"林三三",
//                  @"time":@"11-19 13:32",
//                  @"text":@"像演讲跟新闻访谈类节目，话题无所不包，语体更接近正式场合的口语，同时又有一定深度，还能积累实用的生词，这些最适合作为“学习”材料。",
//                  @"like":@"4",
//                  @"isLike":@"1",
//                  };
//    
//    speakDic3 = @{
//                  @"headImg":@"headImage4",
//                  @"name":@"张小明",
//                  @"time":@"11-17 22:48",
//                  @"text":@"美剧顶多算是对英文听说“有帮助”，远远谈不上“适合学习”，不适合正襟危坐逐句逐字查字典，一句句跟读模仿来“学习”，更适合学累了看一两集放松放松。",
//                  @"like":@"23",
//                  @"isLike":@"1",
//                  };
//    
//    speakDic4 = @{
//                  @"headImg":@"headImage1",
//                  @"name":@"刘可可",
//                  @"time":@"10-28 5:10",
//                  @"text":@"This outdoors activity is really impressive and beneficial. Not only did it get us closer to the nature and relieve pressure form us, it also promote the friendship among us.",
//                  @"like":@"11",
//                  @"isLike":@"0",
//                  };
//    
//    speakDic5 = @{
//                  @"headImg":@"headImage3",
//                  @"name":@"李名名",
//                  @"time":@"10-22 18:22",
//                  @"text":@"一直坚持着.用铁勺太冰冷；用瓷勺又太脆弱； 一只只木勺,刻出了纹理安然,刻出了天荒地老.一如岁月中隐忍着的幸福,不张狂,举手投足间悄然绽放。",
//                  @"like":@"6",
//                  @"isLike":@"0",
//                  };
//    
//    speakDic6 = @{
//                  @"headImg":@"headImage6",
//                  @"name":@"王东东",
//                  @"time":@"9-17 9:41",
//                  @"text":@"Then the wandering soul wild crane stands still the memory river Listen to whistle play tightly ring slowly,Water rises a ship to go medium long things of the past.Wait for a ship’s person Wait for one and other,But hesitate always should ascend which ship Missed Had to consign the hope to next time,Finally what to wait for until has no boats and ships to come and go,Sunset west .",
//                  @"like":@"39",
//                  @"isLike":@"1",
//                  };
//    
//    [speakMuArr addObject:speakDic1];
//    [speakMuArr addObject:speakDic2];
//    [speakMuArr addObject:speakDic3];
//    [speakMuArr addObject:speakDic4];
//    [speakMuArr addObject:speakDic5];
//    [speakMuArr addObject:speakDic6];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return speakMuArr.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityTableViewCellIdentify];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"CommunityTableViewCell" owner:self options:nil][0];
        }
        cell.delegate = self;
        cell.index = indexPath;
        CGFloat height;
        height = 101;
        
        cell.personalHeadImgView.image = [UIImage imageNamed:[UserDefaultsUtils valueWithKey:@"detailHeadImage"]];
        cell.personalNameLabel.text = [UserDefaultsUtils valueWithKey:@"detailName"];
        cell.personalTimeLabel.text = [UserDefaultsUtils valueWithKey:@"detailTime"];
        
        if ([[UserDefaultsUtils valueWithKey:@"detailIsFollow"]  isEqual: @"0"]) {
            [cell.personalCollectBtn setSelected:NO];
        }
        else{
            [cell.personalCollectBtn setSelected:YES];
        }
        
        if ([[UserDefaultsUtils valueWithKey:@"detailText"]  isEqual: @"-1"]) {
            cell.detailView.hidden = YES;
        }
        else{
            cell.detailView.width = SCREEN_WIDTH;
            cell.detailLabel.width = SCREEN_WIDTH;
            cell.detailLabel.text = [UserDefaultsUtils valueWithKey:@"detailText"];
            cell.detailLabel.numberOfLines = 0;
            [cell.detailLabel sizeToFit];
            cell.detailView.height = cell.detailLabel.frame.size.height;
            height += cell.detailLabel.frame.size.height + 20;

        }
        
        if ([[UserDefaultsUtils valueWithKey:@"detailImage"]  isEqual: @"-1"]) {
            cell.pictureView.hidden = YES;
        }
        else{
            cell.pictureView.hidden = NO;
            cell.pictureImage.image = [UIImage imageNamed:[UserDefaultsUtils valueWithKey:@"detailImage"]];
            height += 150;
        }
        
        if ([[UserDefaultsUtils valueWithKey:@"detailVideo"]  isEqual: @"-1"]) {
            cell.videoView.hidden = YES;
        }
        else{
            cell.videoView.hidden = NO;
            cell.videoImage.image = [UIImage imageNamed:[UserDefaultsUtils valueWithKey:@"detailVideo"]];
            height += 205;
        }
        
        [cell.replyBtn setTitle:[UserDefaultsUtils valueWithKey:@"detailReply"] forState:UIControlStateNormal];
        
        if ([[UserDefaultsUtils valueWithKey:@"detailIsLike"]  isEqual: @"0"]) {
            [cell.likeBtn setSelected:NO];
        }
        else{
            [cell.likeBtn setSelected:YES];
        }
        [cell.likeBtn setTitle:[UserDefaultsUtils valueWithKey:@"detailLike"] forState:UIControlStateNormal];
        cell.likePerson = [[UserDefaultsUtils valueWithKey:@"detailLike"] integerValue];
        CGRect labelRect = cell.frame;
        labelRect.size.height = height;
        cell.frame = labelRect;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        PEDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPEDetailTableViewCell];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"PEDetailTableViewCell" owner:self options:nil][0];
        }
        CGFloat height;
        height = 60;
        
        cell.headImg.image = [UIImage imageNamed:speakMuArr[indexPath.row][@"headImage"]];
        cell.nickNameLabel.text = speakMuArr[indexPath.row][@"nickName"];
        cell.speakTimeLabel.text = speakMuArr[indexPath.row][@"time"];
        [cell.speakLikeBtn setTitle:speakMuArr[indexPath.row][@"like"] forState:UIControlStateNormal];
        
        cell.speakContentLabel.width = SCREEN_WIDTH;
        cell.speakContentLabel.text = speakMuArr[indexPath.row][@"text"];
        cell.speakContentLabel.numberOfLines = 0;
        [cell.speakContentLabel sizeToFit];
        cell.speakContentLabel.height = cell.speakContentLabel.frame.size.height;
        height += cell.speakContentLabel.frame.size.height + 10;
        
        CGRect labelRect = cell.frame;
        labelRect.size.height = height;
        cell.frame = labelRect;
        return cell;
    }
    else{
        return nil;
    }
    
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return 80.0f;
    }
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        headerView.backgroundColor = Rgb2UIColor(245, 245, 245, 1.f);
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 50)];
        baseView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
        titleLabel.text = @"全部评论";
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = TEXT_COLOR_SECONDARY;
        
        UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        headLineView.backgroundColor = LINE_COLOR;
        UIView *footLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
        footLineView.backgroundColor = LINE_COLOR;
        
        [baseView addSubview:headLineView];
        [baseView addSubview:footLineView];
        [baseView addSubview:titleLabel];
        [headerView addSubview:baseView];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        CommunityTableViewCell *cell=(CommunityTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    else if(indexPath.section == 1){
        PEDetailTableViewCell *cell=(PEDetailTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 5) {
            NSLog(@"cell%f",cell.frame.size.height);
        }
        return cell.frame.size.height;
    }
    return CGFLOAT_MIN;
}

#pragma mark CommunityBtnCellDelegate

- (BOOL)FollowBtnCellDelegate:(NSIndexPath *)index{
    return [tableMuArr[index.row][@"isFollow"] boolValue];
}

-(BOOL)LikeBtnCellDelegate:(NSIndexPath *)index{
    return [tableMuArr[index.row][@"isLike"] boolValue];
}

- (void)ReplayBtnCellDelegate:(NSIndexPath *)index{
    [_messageField becomeFirstResponder];
}

@end
