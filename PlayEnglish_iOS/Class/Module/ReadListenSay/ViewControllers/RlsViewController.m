//
//  RlsViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/10/15.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "RlsViewController.h"
#import "RlsWordTableViewCell.h"
#import "PPLabelTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "TYAttributeLabelTableViewCell.h"
#import "RLSSayButtonView.h"
#import "LVRecordTool.h"

#define kExamTextFieldWidth 80
#define kExamTextFieldHeight 20
#define kAttrLabelWidth (CGRectGetWidth(self.view.frame)-20)
#define kTextFieldTag 1000

@interface RlsViewController ()<UITableViewDelegate,UITableViewDataSource,RlsWordTableViewCellDelegate,PPLabelDelegate,TYAttributedLabelDelegate,UITextFieldDelegate,LVRecordToolDelegate>{
    HcdCacheVideoPlayer *play;//视频播放
    AVAudioPlayer *avPlayer;//MP3播放
    AVAudioPlayer *voicePlayer;
    
    //倒计时
    long long secondsCountDown; //倒计时总时长
    long long secondsBegin; //倒计时计时
    NSTimer *countDownTimer;//计时器
    
    BOOL isFold;//用于判断卡片是否隐藏
    UIButton *cellRightButton;//回答正确时出现的button
    
    int tagNum;
    NSMutableArray *fillWordArr;//填写的单词数组
    
    //卡片数据
    NSMutableArray *tableMuArr;
    NSInteger wordId;

}
/** 听 填空的文本容器 */
@property (nonatomic,strong) TYTextContainer *textContainer;
/** 看听说模式 */
@property (nonatomic, assign) RLSModelState state;
/** 单词卡片填写正确与否 */
@property (nonatomic, assign) RLSJudgeYesOrNo judge;
/** 看 听 存储,字典的key 值 */
@property(nonatomic,strong)NSMutableArray *lrcTimeAry;
/** 说 存储,字典的key 值 */
@property(nonatomic,strong)NSMutableArray *sayTimeAry;
/** 字典 存储歌词 */
@property(strong,nonatomic)NSMutableDictionary *lrcDic;
/** 返回view */
@property (weak, nonatomic) IBOutlet UIImageView *returnImageView;
/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;//---
/** 看按钮 */
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
/** 听按钮 */
@property (weak, nonatomic) IBOutlet UIButton *listenBtn;
/** 说按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sayBtn;
/** 进度条控制器 */
@property (weak, nonatomic) IBOutlet UIButton *playControlBtn;
/** 隐藏单词按钮 */
@property (weak, nonatomic) IBOutlet UIButton *foldBtn;
/**  */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 已开始时间label */
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
/** 总时间label */
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
/** 歌词句子总数label */
@property (weak, nonatomic) IBOutlet UILabel *sayLabel;
/** 喜欢按钮 */
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;//---
/** 观看人数按钮 */
@property (weak, nonatomic) IBOutlet UIButton *lookedBtn;//---
/**  */
@property (weak, nonatomic) IBOutlet UIView *lyricView;
/**  */
@property (strong, nonatomic) IBOutlet UIView *rlsTopView;
/**  */
@property (weak, nonatomic) IBOutlet UIView *videoView;
/**  */
@property (weak, nonatomic) IBOutlet UITableView *lrcTableView;
/**  */
@property (weak, nonatomic) IBOutlet UITableView *wordTableView;
/** 用于记录当前歌词是哪行 */
@property (assign,nonatomic) NSInteger line; //
/**  */
@property (nonatomic,strong) UIView *headerView;
/**  */
@property (nonatomic,strong) RLSSayButtonView *sayButtonView;

/** 录音工具 */
@property (nonatomic, strong) LVRecordTool *recordTool;

@end

@implementation RlsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self setData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareHomeTableViewHeader];//设置headerView
    
    [self setButton];//设置button的动作
    
    [self setSlider];//设置进度条
    
    [self setTableViewDelegate];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;//TableViewWrapperView比Tableview少20像素。是因为自动布局的缘故，设置一下属性就可以解决问题
    
    [self loadData];
    
}

- (void)setData{
    tableMuArr = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HandlerBusiness ServiceWithApicode:ApiCodeGetWordLibrary Parameters:nil Success:^(id data , id msg){
        
        for (int i = 0; i < [data count]; i++) {
            [tableMuArr addObject:data[i]];
        }
        
        [_wordTableView reloadData];
    }Failed:^(NSInteger code ,id errorMsg){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }Complete:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
//    NSDictionary *tableDic1 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic2 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic3 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic4 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic5 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic6 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic7 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic8 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic9 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic10 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic11 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic12 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic13 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic14 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic15 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic16 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic17 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic18 = [[NSDictionary alloc] init];
//    NSDictionary *tableDic19 = [[NSDictionary alloc] init];
//    
//    tableDic1 = @{
//                  @"word":@"Like",
//                  @"pronounce":@"[laɪk]",
//                  @"USpronounce":@"",
//                  @"voice":@"like",
//                  @"mean":@"vt.喜欢；想； 想要； 喜欢做\nadj.相似的； 相同的；\nn.相类似的人[事物]； 喜好； 爱好；种类，类型\nadv.（非正式口语，代替 as）和…一样； 如； （非正式口语，思考说下句话、解释或举例时用）大概； 可能",
//                  };
//    tableDic2 = @{
//                  @"word":@"Down",
//                  @"pronounce":@"[daʊn]",
//                  @"USpronounce":@"",
//                  @"voice":@"down",
//                  @"mean":@"adv.（坐、倒、躺）下； 向下； （表示范围或顺序的限度）下至；\nadj.向下的； 沮丧的； 计算机或计算机系统停机； （以…）落后于对手的\nn.（鸟的）绒羽； 绒毛； 软毛； 汗毛\nvt.放下； （尤指大口或快速地）喝下； 使摔倒； 击落（敌机等）\nvi.[常用于祈使句中]下去； 下来； 卧倒； 下降",
//                  };
//    tableDic3 = @{
//                  @"word":@"Wind",
//                  @"pronounce":@"[wɪnd]",
//                  @"USpronounce":@"[wɪnd]",
//                  @"voice":@"wind",
//                  @"mean":@"n.风； 气流； 吞下的气； 管乐器\nvt.蜿蜒； 缠绕； 上发条； 使喘不过气来\nadj.管乐的；",
//                  };
//    tableDic4 = @{
//                  @"word":@"Sin",
//                  @"pronounce":@"[sɪn]",
//                  @"USpronounce":@"[sɪn]",
//                  @"voice":@"sin",
//                  @"mean":@"n.违背宗教[道德原则]的恶行； 罪恶，罪孽； 过错，罪过； 愚蠢的事，可耻的事\nvi.犯罪，犯过错；\nvt.犯罪；",
//                  };
//    tableDic5 = @{
//                  @"word":@"Already",
//                  @"pronounce":@"[ɔlˈrɛdi]",
//                  @"USpronounce":@"[ɔ:lˈredi]",
//                  @"voice":@"already",
//                  @"mean":@"adv.早已，已经； 先前；",
//                  };
//    tableDic6 = @{
//                  @"word":@"Free",
//                  @"pronounce":@"[fri]",
//                  @"USpronounce":@"[fri:]",
//                  @"voice":@"free",
//                  @"mean":@"adj.自由的； 免费的； 免税的； 空闲的\nadv.免费地； 自由地，无拘束地； 一帆风顺地；\nvt.免除； 释放； 使自由； 解救",
//                  };
//    tableDic7 = @{
//                  @"word":@"Autumn",
//                  @"pronounce":@"[ˈɔtəm]",
//                  @"USpronounce":@"[ˈɔ:təm]",
//                  @"voice":@"autumn",
//                  @"mean":@"n.秋； 秋天； 成熟期； 渐衰期\nadj.秋天的； 秋季的；",
//                  };
//    tableDic8 = @{
//                  @"word":@"Blue",
//                  @"pronounce":@"[blu]",
//                  @"USpronounce":@"[blu:]",
//                  @"voice":@"blue",
//                  @"mean":@"n.蓝色； [复数]蓝色制服； 蓝颜料；\nadj.蓝色的； 沮丧的，忧郁的； 下流的；\nvt.把…染成蓝色； 使成蓝色； 给…用上蓝剂； 用上蓝剂于\nvi.变成蓝色，呈蓝色",
//                  };
//    tableDic9 = @{
//                  @"word":@"Never",
//                  @"pronounce":@"[ˈnɛvɚ]",
//                  @"USpronounce":@"[ˈnevə(r)]",
//                  @"voice":@"never",
//                  @"mean":@"adv.从不，从来没有； 一点也不，决不； <口>不会…吧，没有； 不曾",
//                  };
//    tableDic10 = @{
//                  @"word":@"Dark",
//                  @"pronounce":@"[dɑrk]",
//                  @"USpronounce":@"[dɑ:k]",
//                  @"voice":@"dark",
//                  @"mean":@"adj.黑暗的； 乌黑的； 忧郁的； 神秘的\nn.黑暗； 暗色； 暗处；",
//                  };
//    tableDic11 = @{
//                  @"word":@"Forget",
//                  @"pronounce":@"[fərˈget]",
//                  @"USpronounce":@"[fəˈget]",
//                  @"voice":@"forget",
//                  @"mean":@"vt.忘记，忘却； 忽略，疏忽； 遗落； 忘掉\nvi.忘记； 忽视",
//                  };
//    tableDic12 = @{
//                  @"word":@"Red",
//                  @"pronounce":@"[rɛd]",
//                  @"USpronounce":@"[red]",
//                  @"voice":@"red",
//                  @"mean":@"adj.红色的； （脸）涨红的； 烧红的； 红头发的\nn.红色； 红衣服； 红颜料； 红葡萄酒",
//                  };
//    tableDic13 = @{
//                  @"word":@"Right",
//                  @"pronounce":@"[raɪt]",
//                  @"USpronounce":@"[raɪt]",
//                  @"voice":@"right",
//                  @"mean":@"adv.立刻，马上； 向右，右边； 恰当地； 一直\nadj.右方的； 正确的； 合适的； 好的，正常的\nn.正确，正当； 右边； 权利； 右手\nvt.纠正； 扶直，使正； 整理； 补偿\nvi.（船舶等）复正，恢复平稳；",
//                  };
//    tableDic14 = @{
//                  @"word":@"Easy",
//                  @"pronounce":@"[ˈizi]",
//                  @"USpronounce":@"[ˈi:zi]",
//                  @"voice":@"easy",
//                  @"mean":@"adj.容易的； 舒适的； 宽裕的； 从容的\nadv.容易地； 不费力地； 悠闲地； 缓慢地\nvi.停止划桨（常用作命令）；\nvt.向（水手或划手）发出停划命令；",
//                  };
//    tableDic15 = @{
//                  @"word":@"Old",
//                  @"pronounce":@"[oʊld]",
//                  @"USpronounce":@"[əʊld]",
//                  @"voice":@"old",
//                  @"mean":@"adj.老的； 古老的； 以前的； （用于指称被替代的东西）原来的\nn.古时；",
//                  };
//    tableDic16 = @{
//                  @"word":@"Know",
//                  @"pronounce":@"[noʊ]",
//                  @"USpronounce":@"[nəʊ]",
//                  @"voice":@"know",
//                  @"mean":@"v.知道； 了解； 认识； 确信\nn.知情；",
//                  };
//    tableDic17 = @{
//                  @"word":@"Myself",
//                  @"pronounce":@"[maɪˈsɛlf]",
//                  @"USpronounce":@"[maɪˈself]",
//                  @"voice":@"myself",
//                  @"mean":@"pron.我自己，亲自；",
//                  };
//    tableDic18 = @{
//                  @"word":@"Impossible",
//                  @"pronounce":@"[ɪmˈpɑsəbl]",
//                  @"USpronounce":@"[ɪmˈpɒsəbl]",
//                  @"voice":@"impossible",
//                  @"mean":@"adj.不可能的，做不到的； 难以忍受的； 不会有的，不能相信的；\nn.不可能； 不可能的事",
//                  };
//    tableDic19 = @{
//                  @"word":@"Back",
//                  @"pronounce":@"[bæk]",
//                  @"USpronounce":@"[bæk]",
//                  @"voice":@"back",
//                  @"mean":@"n.背，背部； 背面，反面； 后面，后部； （椅子等的）靠背\nvt.使后退； 支持； 加背书于； 下赌注于\nvi.后退； 倒退；\nadj.背部的； 后面的； 以前的； 拖欠的\nadv.以前； 向后地；",
//                  };
//    
//    
//    [tableMuArr addObject:tableDic1];
//    [tableMuArr addObject:tableDic2];
//    [tableMuArr addObject:tableDic3];
//    [tableMuArr addObject:tableDic4];
//    [tableMuArr addObject:tableDic5];
//    [tableMuArr addObject:tableDic6];
//    [tableMuArr addObject:tableDic7];
//    [tableMuArr addObject:tableDic8];
//    [tableMuArr addObject:tableDic9];
//    [tableMuArr addObject:tableDic10];
//    [tableMuArr addObject:tableDic11];
//    [tableMuArr addObject:tableDic12];
//    [tableMuArr addObject:tableDic13];
//    [tableMuArr addObject:tableDic14];
//    [tableMuArr addObject:tableDic15];
//    [tableMuArr addObject:tableDic16];
//    [tableMuArr addObject:tableDic17];
//    [tableMuArr addObject:tableDic18];
//    [tableMuArr addObject:tableDic19];
}

#pragma mark TableViewDelegat
- (void)setTableViewDelegate{
    self.lrcTableView.dataSource = self;
    self.lrcTableView.delegate = self;
    self.lrcTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lrcTableView.tag = 2002;
    
    self.wordTableView.dataSource = self;
    self.wordTableView.delegate = self;
    self.wordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.wordTableView.tag = 2001;

}

#pragma mark 加载数据
- (void)loadData{
    self.state = RLSReadState;                      //刚进来时时看模式
    
    [_returnBtn setTitle:_titleName forState:0];    //读取歌曲/视频名称
    
    [_lookedBtn setTitle:_lookedPerson forState:0]; //读取观看人数
    if (_isLike) {
        _likeBtn.selected = YES;                    //读取是否喜欢
    }
    else{
        _likeBtn.selected = NO;
    }
    fillWordArr = [[NSMutableArray alloc] init];
    tagNum = 0;
    _foldBtn.selected = YES;
    isFold = 1;
    wordId = 0;
}

#pragma mark tableHeaderView
- (void)prepareHomeTableViewHeader{
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 489)];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RlsViewController" owner:self options:nil];
    
    self.rlsTopView = [nib objectAtIndex:1];
    
    self.rlsTopView.frame = CGRectMake(0,0, SCREEN_WIDTH,489);

    [self.headerView addSubview:self.rlsTopView];
    
    self.wordTableView.tableHeaderView = self.headerView;
    
    [self prepareSayBtnView];
}

#pragma mark sayBtnView
- (void)prepareSayBtnView{

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RLSSayButtonView" owner:self options:nil];
    
    self.sayButtonView = [nib objectAtIndex:0];
    
    self.sayButtonView.frame = CGRectMake(0, SCREEN_HEIGHT - 240, SCREEN_WIDTH, 240);
    
    self.recordTool = [LVRecordTool sharedRecordTool];
    
    self.sayButtonView.timeBackView.layer.cornerRadius = 15.0f;
    self.sayButtonView.timeBackView.layer.masksToBounds = YES;
    self.sayButtonView.userTimeLabel.text = @"0.0s";
    self.sayButtonView.timeLabel.text = @"原句用时0.0s";
    self.sayButtonView.userResultLabel.attributedText = [self userResult:0];
    
    [self.view addSubview:self.sayButtonView];
    
    self.sayButtonView.hidden = YES;
}

- (NSMutableAttributedString *)userResult:(NSInteger)result{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本句得分：%ld",(long)result]];
    [attrStr addAttributes:@{
                             NSForegroundColorAttributeName : TEXT_COLOR_MAIN
                             } range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttributes:@{
                             NSForegroundColorAttributeName : THEME_COLOR
                             } range:NSMakeRange(5, attrStr.length-5)];
    return attrStr;
}

#pragma mark  视频加载
- (void)setVideoPlay{
    play = [HcdCacheVideoPlayer sharedInstance];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    [self.videoView addSubview:view];
    
    [play playWithUrl:[NSURL URLWithString:_videoURL] showView:view andSuperView:self.videoView withCache:YES];
    
    [play toolViewHidden];//隐藏工具栏
}

#pragma mark 歌曲解析
- (void)setMusicPath{
    
    //获取歌曲路径
    NSString *path = [[NSBundle mainBundle]pathForResource:_musicName ofType:@".mp3"];
    //获取歌曲URL
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;//传地址,就说明要在该方法内部对对象进行修改;
    
    //创建播放音乐对象
    avPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (error == nil) {
        NSLog(@"正常播放");
    } else {
        NSLog(@"播放失败%@", error);
    }
    //准备播放
    [avPlayer prepareToPlay];
    //开始播放
    [avPlayer play];
    
    secondsCountDown = avPlayer.duration;//歌曲总时间
    secondsBegin = 0;
}

//对歌词进行解析;
- (void)parserLrc {
    //读取歌词内容;
    NSString *path;
    if (self.state == RLSListenState) {
        path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@_re",_musicName] ofType:@"lrc"];
    }
    else{
        path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",_musicName] ofType:@"lrc"];
    }
    
    //NSString *error = nil;
    NSString *contentStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // NSLog(@"%@",contentStr);
    self.lrcDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.lrcTimeAry = [NSMutableArray arrayWithCapacity:0];
    self.sayTimeAry = [NSMutableArray arrayWithCapacity:0];
    //换行进行分割; 获取每一行的歌词;
    NSArray *linArr = [contentStr componentsSeparatedByString:@"\n"];
    
    // NSLog(@"linArr= %@",linArr);
    for (NSString *string in linArr) {
        if (string.length > 7) {
            NSString *str1 = [string substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [string substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"]&&[str2 isEqualToString:@"."]) {
                // NSLog(@"%@",string);
                //截取歌词和时间;
                NSString *sayStr = [string substringWithRange:NSMakeRange(1, 8)];
                NSString *timeStr = [string substringWithRange:NSMakeRange(1, 5)];
                NSString *lrcStr = [string substringFromIndex:10   ];
                //NSLog(@"%@,%@",timeStr,lrcStr);
                //放入集合中;
                [self.sayTimeAry addObject:sayStr];
                [self.lrcTimeAry addObject:timeStr];
                [self.lrcDic setObject:lrcStr forKey:timeStr];
            }
        }
    }
}

#pragma mark 倒计时

- (void)setSlider{
    //获取视频
    [self setVideoPlay];
    //获取歌曲
//    [self setMusicPath];
    //加载并解析歌词
    [self parserLrc];
    
    [self setStartTime];//设置开始时间label
    [self setEndTime];//设置结束时间label
    [self setsayLabel:0];
    _sayLabel.hidden = YES;
    
    //设置slider属性
    _progressSlider.userInteractionEnabled = YES; 
    _progressSlider.value = 0;
    _progressSlider.maximumValue = 1;
    _progressSlider.minimumValue = 0;
    [_progressSlider setThumbImage:[UIImage imageNamed:@"rls_thumb"] forState:UIControlStateNormal];
    [_progressSlider addTarget:self action:@selector(playSliderChange:) forControlEvents:UIControlEventValueChanged]; //拖动滑竿更新时间
    [_progressSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpInside];  //松手,滑块拖动停止
    [_progressSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpOutside];
    [_progressSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchCancel];
    
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)setEndTime{
    long long min,sec;
    min = secondsCountDown/60;
    sec = secondsCountDown%60;
    _endLabel.text = [NSString stringWithFormat:@"%02lld:%02lld",min,sec];
}

- (void)setStartTime{
    long long min,sec;
    min = secondsBegin/60;
    sec = secondsBegin%60;
    _startLabel.text = [NSString stringWithFormat:@"%02lld:%02lld",min,sec];
}

- (void)setsayLabel:(NSInteger)ints{
    _sayLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)ints,(unsigned long)self.lrcDic.count];
}

//倒计时
-(void)timeFireMethod{
    secondsBegin += 1;
    if (secondsBegin == 1) {
        secondsCountDown = play.duration;//获取视频总长度
        [self setEndTime];
    }
    _progressSlider.value = (float)secondsBegin/secondsCountDown;
    if (secondsBegin == secondsCountDown) {
        [countDownTimer invalidate];
        [avPlayer stop];
        [play stop];
    }
    else{
        [self setStartTime];
        NSString *currentString = [NSString stringWithFormat:@"%02lld:%02lld",secondsBegin / 60 ,secondsBegin % 60];
        //判断数组是否包含某个元素;
        if ([self.lrcTimeAry containsObject:currentString]) {
            self.line = [self.lrcTimeAry indexOfObject:currentString];
            [self.lrcTableView reloadData];
            //选中 tableView 的这一行;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.line inSection:0];
            [self.lrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

#pragma mark setButton
- (void)setButton{
    [_returnBtn addTarget:self action:@selector(backToView) forControlEvents:UIControlEventTouchUpInside];
    [_readBtn addTarget:self action:@selector(read) forControlEvents:UIControlEventTouchUpInside];
    [_listenBtn addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
    [_sayBtn addTarget:self action:@selector(say) forControlEvents:UIControlEventTouchUpInside];
    [_playControlBtn addTarget:self action:@selector(playControl) forControlEvents:UIControlEventTouchUpInside];
    [_likeBtn addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    [_lookedBtn addTarget:self action:@selector(looked) forControlEvents:UIControlEventTouchUpInside];
    [_foldBtn addTarget:self action:@selector(fold) forControlEvents:UIControlEventTouchUpInside];
    [self.sayButtonView.lastVoiceBtn addTarget:self action:@selector(lastVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.sayButtonView.nextVoiceBtn addTarget:self action:@selector(nextVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.sayButtonView.recordVoiceBtn addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.sayButtonView.recordVoiceBtn addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.sayButtonView.recordVoiceBtn addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.sayButtonView.voiceBtn addTarget:self action:@selector(voice) forControlEvents:UIControlEventTouchUpInside];
    _readBtn.selected = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFold == 1) {
        if (tableView.tag == 2001) {
            return 0;
        }
        else if(tableView.tag == 2002){
            return self.lrcTimeAry.count;
        }
        else{
            return 0;
        }
    }
    else{
        if (tableView.tag == 2001) {
            return 1;
        }
        else if(tableView.tag == 2002){
            return self.lrcTimeAry.count;
        }
        else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2001) {
        RlsWordTableViewCell *cell=(RlsWordTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    else if(tableView.tag == 2002){
        return 44;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma mark 下面的单词卡片的tableViewCell
    if (tableView.tag == 2001) {
        RlsWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RlsWordTableViewCell"];
        if (!cell) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"RlsWordTableViewCell" owner:self options:nil][0];
        }
        //判断是看模式还是听模式，因为两者的卡片样式不同
        if (self.state == RLSListenState) {
            cell.meansLabel.textColor = [UIColor whiteColor];
            cell.pronounceLabel.textColor = [UIColor whiteColor];
            [cell.voiceBtn setImage:[UIImage imageNamed:@"rls_voice_white"] forState:UIControlStateNormal];
            cell.baseView.backgroundColor = Rgb2UIColor(129, 123, 125, 0.8);
            [cell.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            //cell.addBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        else if(self.state == RLSReadState){
            cell.meansLabel.textColor = TEXT_COLOR_SECONDARY;
            cell.pronounceLabel.textColor = TEXT_COLOR_SECONDARY;
            [cell.voiceBtn setImage:[UIImage imageNamed:@"rls_voice_black"] forState:UIControlStateNormal];
            cell.baseView.backgroundColor = [UIColor whiteColor];
            [cell.addBtn setTitleColor:TEXT_COLOR_THIRDARY forState:UIControlStateSelected];
            //cell.addBtn.layer.borderColor = THEME_COLOR.CGColor;
        }
        else{
            return nil;
        }
        
        CGFloat height = 144;
        cell.wordLabel.text = tableMuArr[wordId][@"wordName"];
        cell.pronounceLabel.text = tableMuArr[wordId][@"USPronounce"];
        cell.voiceURL = tableMuArr[wordId][@"USVoiceURL"];
        cell.delegate = self;
        cell.meansLabel.text = tableMuArr[wordId][@"mean"];
        cell.meansLabel.numberOfLines = 0;
        [cell.meansLabel sizeToFit];
        
        height += cell.meansLabel.frame.size.height + 20;
        CGRect labelRect = cell.frame;
        labelRect.size.height = height;
        cell.frame = labelRect;
        
        return cell;
    }
#pragma mark 歌词的tableViewCell
    else{
        if (self.state == RLSReadState) {
            PPLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPLabelTableViewCell"];
            if (!cell) {
                cell=[[NSBundle mainBundle]loadNibNamed:@"PPLabelTableViewCell" owner:self options:nil][0];
            }
            cell.ppLabel.delegate = self;
            NSString *key = self.lrcTimeAry[indexPath.row] ;
            cell.ppLabel.text = self.lrcDic[key];
            cell.ppLabel.numberOfLines = 2;
            cell.ppLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //改变 textLabel 的样式;
            if (indexPath.row  == self.line) {
                cell.ppLabel.font = [UIFont systemFontOfSize:18.0];
                cell.ppLabel.textColor = TEXT_COLOR_SECONDARY;
                cell.ppLabel.alpha = 1.0;
            } else {
                cell.ppLabel.font = [UIFont systemFontOfSize:13.0];
                cell.ppLabel.textColor = TEXT_COLOR_THIRDARY;
                cell.ppLabel.alpha = 0.5;
            }
            return cell;
        }
        else if(self.state == RLSListenState){
            TYAttributeLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYAttributeLabelTableViewCell"];
            if (!cell) {
                cell=[[NSBundle mainBundle]loadNibNamed:@"TYAttributeLabelTableViewCell" owner:self options:nil][0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *key = self.lrcTimeAry[indexPath.row] ;
            cell.TYLabelView.text = self.lrcDic[key];
            cell.TYLabelView.numberOfLines = 2;
            
            [self createTextContainer:cell.TYLabelView.text];
            [_textContainer setTextAlignment:kCTTextAlignmentCenter];//设置_textContainer对齐方式
            
            //改变 textLabel 的样式;
            if (indexPath.row  == self.line) {
                _textContainer.font = [UIFont systemFontOfSize:18.0];
                _textContainer.textColor = TEXT_COLOR_SECONDARY;
                cell.TYLabelView.alpha = 1.0;
            } else {
                _textContainer.font = [UIFont systemFontOfSize:13.0];
                _textContainer.textColor = TEXT_COLOR_THIRDARY;
                cell.TYLabelView.alpha = 0.5;
            }
            
            //cell.TYLabelView.delegate = self;
            cell.TYLabelView.textContainer = _textContainer;
            return cell;
        }
        else if (self.state == RLSSayState){
            PPLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PPLabelTableViewCell"];
            if (!cell) {
                cell=[[NSBundle mainBundle]loadNibNamed:@"PPLabelTableViewCell" owner:self options:nil][0];
            }
            cell.ppLabel.delegate = self;
            NSString *key = self.lrcTimeAry[indexPath.row] ;
            cell.ppLabel.text = self.lrcDic[key];
            cell.ppLabel.numberOfLines = 2;
            cell.ppLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //改变 textLabel 的样式;
            if (indexPath.row  == self.line) {
                cell.ppLabel.font = [UIFont systemFontOfSize:18.0];
                cell.ppLabel.textColor = TEXT_COLOR_SECONDARY;
                cell.ppLabel.alpha = 1.0;
            } else {
                cell.ppLabel.font = [UIFont systemFontOfSize:13.0];
                cell.ppLabel.textColor = TEXT_COLOR_THIRDARY;
                cell.ppLabel.alpha = 0.0f;
            }
            
            //设置原句用时
            [self setsayLabel:self.line];
            float aMin = [[self.sayTimeAry[self.line] substringWithRange:NSMakeRange(1, 2)] floatValue];
            float bMin = [[self.sayTimeAry[self.line+1] substringWithRange:NSMakeRange(1, 2)] floatValue];
            float aSec = [[self.sayTimeAry[self.line] substringWithRange:NSMakeRange(3, 4)] floatValue];
            float bSec = [[self.sayTimeAry[self.line+1] substringWithRange:NSMakeRange(3, 4)] floatValue];
            
            if (bMin == aMin + 1) {
                self.sayButtonView.timeLabel.text = [NSString stringWithFormat:@"原句用时%.2fs",bSec + 60 - aSec];
            }
            else{
                self.sayButtonView.timeLabel.text = [NSString stringWithFormat:@"原句用时%.2fs",bSec- aSec];
            }
            
            return cell;

        }
        else{
            return nil;
        }
    }
}
//
- (void)createTextContainer:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    
    // 整体设置属性
    //textContainer.linesSpacing = 0;
    //textContainer.paragraphSpacing = 0;
    
    // 填空题
    NSArray *blankStorage = [self parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    // 生成 TYTextContainer
    _textContainer = [textContainer createTextContainerWithTextWidth:kAttrLabelWidth];
    
}

// 解析填空
- (NSArray *)parseTextFieldsWithString:(NSString *)string
{
    NSMutableArray *textFieldArray = [NSMutableArray array];
    __weak RlsViewController *weakSelf = self;
    [string enumerateStringsMatchedByRegex:@"\\[@\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if (captureCount > 0) {
            TExamTextField *textField = [[TExamTextField alloc]initWithFrame:CGRectMake(0, 0, kExamTextFieldWidth, kExamTextFieldHeight)];
            textField.textColor = [UIColor colorWithRed:255.0/255 green:155.0/255 blue:26.0/255 alpha:1];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.font = [UIFont systemFontOfSize:18];
            textField.delegate = weakSelf;
            textField.tag = kTextFieldTag + tagNum;
            tagNum += 1;
            TYViewStorage *viewStorage = [[TYViewStorage alloc]init];
            viewStorage.range = capturedRanges[0];
            viewStorage.view = textField;
            
            [textFieldArray addObject:viewStorage];
        }
    }];
    
    return textFieldArray.count > 0 ?[textFieldArray copy] : nil;
}


#pragma mark --看模式下，点击歌曲单词所触发的动作

- (void)label:(PPLabel *)label didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    [self highlightWordContainingCharacterAtIndex:charIndex AndPPLabelText:label.text];
}

- (void)label:(PPLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    [self highlightWordContainingCharacterAtIndex:charIndex AndPPLabelText:label.text];
}

- (void)label:(PPLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
}

- (void)label:(PPLabel *)label didCancelTouch:(UITouch *)touch {
    
}

#pragma mark -- 听模式下，点击textfield时  textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [_playControlBtn setSelected:NO];//停止播放视频
    [self playControl];
    
    return  true;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];//隐藏键盘
    
    //判断正确与否
    for (int i = 0; i < tableMuArr.count; i++) {
        NSString *str = tableMuArr[i][@"voice"];
        if ([str compare:textField.text]==NSOrderedSame) {
            self.judge = RLSWordIsRight;
            [self judgeWordIsRightOrWrong];
            return  true;
        }
        else if([textField.text isEqual:nil]){
            return true;
        }
        else{
            NSInteger str = textField.tag - kTextFieldTag;
            if (str >= 18) {
                str = 17;
            }
            wordId = str;
            self.judge = RLSWordIsWrong;
            [self judgeWordIsRightOrWrong];
        }

    }
    
    return true;
}

#pragma mark -- 看模式下，点击歌曲单词 显示这个单词

- (void)highlightWordContainingCharacterAtIndex:(CFIndex)charIndex AndPPLabelText:(NSString *)text{
    
    if (charIndex==NSNotFound) {
        
        //user did nat click on any word
        return;
    }
    
    NSString* string = text;
    NSLog(@"%@",string);
    
    //compute the positions of space characters next to the charIndex
    NSRange end = [string rangeOfString:@" " options:0 range:NSMakeRange(charIndex, string.length - charIndex)];
    NSRange front = [string rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, charIndex)];
    
    if (front.location == NSNotFound) {
        front.location = 0; //first word was selected
    }
    
    if (end.location == NSNotFound) {
        end.location = string.length-1; //last word was selected
    }
    
    NSRange wordRange = NSMakeRange(front.location, end.location-front.location);
    
    if (front.location!=0) { //fix trimming
        wordRange.location += 1;
        wordRange.length -= 1;
    }
    
    NSString *rangeStr = [string substringWithRange:wordRange];
    
    NSLog(@"%@。",rangeStr);
    for (int i = 0; i < tableMuArr.count; i++) {
        NSString *str = tableMuArr[i][@"USVoiceURL"];
        if ([str compare:rangeStr]==NSOrderedSame) {
            _foldBtn.selected = NO;
            isFold = 0;
            wordId = i;
            [_wordTableView reloadData];
        }
    }
}


#pragma mark RlsWordCellDelegate
//AVAudioPlayer这个东西需要全局定义 不然是不能播放的！！！！！！！
- (void)voiceBtnDelegate:(NSString *)str{
    //获取单词发音路径
    NSString *path = [[NSBundle mainBundle]pathForResource:str ofType:@".mp3"];
    //获取单词发音URL
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;//传地址,就说明要在该方法内部对对象进行修改;
    
    //创建播放音乐对象
    voicePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (error == nil) {
        NSLog(@"正常播放");
    } else {
        NSLog(@"播放失败%@", error);
    }
    //准备播放
    [voicePlayer prepareToPlay];
    //开始播放
    [voicePlayer play];
}

#pragma mark - 事件响应

//手指结束拖动，播放器从当前点开始播放，开启滑竿的时间走动
- (void)playSliderChangeEnd:(UISlider *)slider
{
    _playControlBtn.selected = NO;
    [play seekToTime:slider.value*secondsCountDown];
    [avPlayer playAtTime:slider.value*secondsCountDown];
    secondsBegin = slider.value*secondsCountDown;
}

//手指正在拖动，播放器继续播放，但是停止滑竿的时间走动
- (void)playSliderChange:(UISlider *)slider
{
    _playControlBtn.selected = YES;
    secondsBegin = slider.value*secondsCountDown;
}

#pragma mark 设置卡片模式（对或错）
//设置正确时显示的button
- (void)setCellRight{
    cellRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    [cellRightButton addTarget:self action:@selector(cellRight) forControlEvents:UIControlEventTouchUpInside];
    cellRightButton.backgroundColor = THEME_COLOR;
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-54)/2, 16, 54, 18)];
    rightLabel.font = [UIFont systemFontOfSize:17];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.text = @"答对啦";
    [cellRightButton addSubview:rightLabel];
    [self.view addSubview:cellRightButton];
    cellRightButton.hidden = YES;
}

- (void)judgeWordIsRightOrWrong{
    if (self.judge == RLSWordIsNull) {
        cellRightButton.hidden = YES;
        isFold = 1;
        [_wordTableView reloadData];
    }
    else if (self.judge == RLSWordIsRight){
        _returnImageView.hidden = YES;
        _returnBtn.hidden = YES;
        _readBtn.hidden = YES;
        _listenBtn.hidden = YES;
        _sayBtn.hidden = YES;
        cellRightButton.hidden = NO;
        isFold = 1;
        [_wordTableView reloadData];
    }
    else if(self.judge == RLSWordIsWrong){
        _returnImageView.hidden = NO;
        _returnBtn.hidden = NO;
        _readBtn.hidden = NO;
        _listenBtn.hidden = NO;
        _sayBtn.hidden = NO;
        cellRightButton.hidden = YES;
        isFold = 0;
        [_wordTableView reloadData];
    }
}

#pragma mark - setButtonAction
- (void)backToView{
    [avPlayer stop];
    [play stop];
    [self.navigationController popViewControllerAnimated:YES];
}
  #pragma mark 点击 看
- (void)read{
    if (!_readBtn.isSelected) {
        _readBtn.selected = YES;
        _listenBtn.selected = NO;
        _sayBtn.selected = NO;
        
        _startLabel.hidden = NO;
        _endLabel.hidden = NO;
        _sayLabel.hidden = YES;
        
        self.state = RLSReadState;
        [self parserLrc];//重新解析歌词
        [self.lrcTableView reloadData];
        
        self.sayButtonView.hidden = YES;
        self.wordTableView.scrollEnabled = YES;
        
        _foldBtn.selected = YES;
        [self fold];//显示下面的单词卡片
        _foldBtn.enabled = YES;//使隐藏单词卡片的按钮可以按
    }
    else{
       //再次点击没变化
    }
}
  #pragma mark 点击 听
- (void)listen{
    if (!_listenBtn.isSelected) {
        _listenBtn.selected = YES;
        _readBtn.selected = NO;
        _sayBtn.selected = NO;
        
        _startLabel.hidden = NO;
        _endLabel.hidden = NO;
        _sayLabel.hidden = YES;
        
        self.state = RLSListenState;
        self.judge = RLSWordIsNull;
        [self parserLrc];//重新解析歌词
        [self.lrcTableView reloadData];
        
        self.sayButtonView.hidden = YES;
        self.wordTableView.scrollEnabled = YES;
        
        //[self fold];//隐藏下面的单词卡片
        _foldBtn.enabled = NO;//使隐藏单词卡片的按钮不能按
        [self setCellRight];//初始化正确时出现的button
        [self judgeWordIsRightOrWrong];
    }
    else{
        //再次点击没变化
    }
}
  #pragma mark 点击 说
- (void)say{
    if (!_sayBtn.isSelected) {
        _sayBtn.selected = YES;
        _readBtn.selected = NO;
        _listenBtn.selected = NO;
        
        _startLabel.hidden = YES;
        _endLabel.hidden = YES;
        _sayLabel.hidden = NO;
        
        self.state = RLSSayState;
        [self parserLrc];//重新解析歌词
        [self.lrcTableView reloadData];
        
        self.sayButtonView.hidden = NO;
        self.wordTableView.scrollEnabled = NO;
        
    }
    else{
        //再次点击没变化
    }
}

- (void)playControl{
    
    if (!_playControlBtn.isSelected) {
        [countDownTimer setFireDate:[NSDate distantFuture]];
        _playControlBtn.selected = YES;
        [avPlayer pause];
        [play pause];
    }
    else{
        [countDownTimer setFireDate:[NSDate date]];
        _playControlBtn.selected = NO;
        [avPlayer play];
        [play resume];
    }
}

- (void)like{
    if (!_likeBtn.isSelected) {
        _likeBtn.selected = YES;
    }
    else{
        _likeBtn.selected = NO;
    }
}

- (void)looked{

}

- (void)fold{
    if (!_foldBtn.isSelected) {
        _foldBtn.selected = YES;
        isFold = 1;
        [_wordTableView reloadData];
    }
    else{
        _foldBtn.selected = NO;
        isFold = 0;
        [_wordTableView reloadData];
    }
}

- (void)cellRight{
    NSLog(@"cellRight");
    _returnImageView.hidden = NO;
    _returnBtn.hidden = NO;
    _readBtn.hidden = NO;
    _listenBtn.hidden = NO;
    _sayBtn.hidden = NO;
    cellRightButton.hidden = YES;
    [_playControlBtn setSelected:YES];//停止播放视频
    [self playControl];
}

- (void)lastVoice{
    if (self.line != 0) {
        self.line -= 1;
        [self.lrcTableView reloadData];
        //选中 tableView 的这一行;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.line inSection:0];
        [self.lrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        //设置当前用时为0
        self.sayButtonView.userTimeLabel.text = @"0.0s";
        //设置原句用时
        [self setsayLabel:self.line];
        float aMin = [[self.sayTimeAry[self.line] substringWithRange:NSMakeRange(1, 2)] floatValue];
        float bMin = [[self.sayTimeAry[self.line+1] substringWithRange:NSMakeRange(1, 2)] floatValue];
        float aSec = [[self.sayTimeAry[self.line] substringWithRange:NSMakeRange(3, 4)] floatValue];
        float bSec = [[self.sayTimeAry[self.line+1] substringWithRange:NSMakeRange(3, 4)] floatValue];

        if (bMin == aMin + 1) {
            self.sayButtonView.timeLabel.text = [NSString stringWithFormat:@"原句用时%.2fs",bSec + 60 - aSec];
        }
        else{
            self.sayButtonView.timeLabel.text = [NSString stringWithFormat:@"原句用时%.2fs",bSec- aSec];
        }
        [play seekToTime:aMin*60+aSec];
    }
}

- (void)nextVoice{
    if (self.line != self.lrcDic.count-1) {
        self.line += 1;
        [self.lrcTableView reloadData];
        //选中 tableView 的这一行;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.line inSection:0];
        [self.lrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        //设置当前用时为0
        self.sayButtonView.userTimeLabel.text = @"0.0s";
        //设置原句用时
        [self setsayLabel:self.line];
        float aMin = [[self.sayTimeAry[self.line] substringWithRange:NSMakeRange(1, 2)] floatValue];
        float bMin = [[self.sayTimeAry[self.line+1] substringWithRange:NSMakeRange(1, 2)] floatValue];
        float aSec = [[self.sayTimeAry[self.line] substringWithRange:NSMakeRange(3, 4)] floatValue];
        float bSec = [[self.sayTimeAry[self.line+1] substringWithRange:NSMakeRange(3, 4)] floatValue];

        if (bMin == aMin + 1) {
            self.sayButtonView.timeLabel.text = [NSString stringWithFormat:@"原句用时%.2fs",bSec + 60 - aSec];
        }
        else{
            self.sayButtonView.timeLabel.text = [NSString stringWithFormat:@"原句用时%.2fs",bSec- aSec];
        }
        [play seekToTime:aMin*60+aSec];
    }
}

#pragma mark - 录音
#pragma mark - 录音按钮事件
// 按下
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
    [_playControlBtn setSelected:NO];//停止播放视频
    [self playControl];

    [self.recordTool startRecording];
}

// 点击
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
    double currentTime = self.recordTool.recorder.currentTime;
    self.sayButtonView.userTimeLabel.text = [NSString stringWithFormat:@"%.2fs",currentTime];
    NSLog(@"%lf", currentTime);
    if (currentTime < 2) {
        
        //self.imageView.image = [UIImage imageNamed:@"mic_0"];
        [self alertWithMessage:@"说话时间太短"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
        });
    } else {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordTool stopRecording];
            dispatch_async(dispatch_get_main_queue(), ^{
                //self.imageView.image = [UIImage imageNamed:@"mic_0"];
            });
        });
        // 已成功录音
        NSLog(@"已成功录音");
        
        [CustomHUD createHudCustomShowContent:@"小E正在分析\n您的语音"];
        [self performSelector:@selector(hiddenHud) withObject:nil afterDelay:2.4];
        
        
    }
}

/**
 *  隐藏HUD
 */
-(void)hiddenHud
{
    int x = arc4random() % 40;

    self.sayButtonView.userResultLabel.attributedText = [self userResult:x];
    [CustomHUD stopHidden];
    
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"本次得分：%d分\n再接再厉!",x] preferredStyle:UIAlertControllerStyleAlert];
    [alterController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
    }]];
    [self presentViewController:alterController animated:YES completion:nil];
}

// 手指从按钮上移除
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
    //self.imageView.image = [UIImage imageNamed:@"mic_0"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:@"已取消录音"];
        });
    });
    
}

#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_DISPLAYNAME message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - 播放录音
- (void)voice {
    [self.recordTool playRecordingFile];
}

- (void)dealloc {
    [self.recordTool stopPlaying];
    [self.recordTool stopRecording];
}

#pragma mark - LVRecordToolDelegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no {
    
//    NSString *imageName = [NSString stringWithFormat:@"mic_%d", no];
//    self.imageView.image = [UIImage imageNamed:imageName];
}



@end
