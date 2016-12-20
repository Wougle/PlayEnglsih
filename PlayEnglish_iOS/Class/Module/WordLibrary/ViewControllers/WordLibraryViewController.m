//
//  WordLibraryViewController.m
//  PlayEnglish_iOS
//
//  Created by KentonYu on 16/10/15.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "WordLibraryViewController.h"
#import "WordLibraryCollectionViewFlowLayout.h"
#import "WordLibraryCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
static NSString *const WordLibraryViewCollectionViewCellIdentity = @"WordLibraryViewCollectionViewCellIdentity";

@interface WordLibraryViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITextFieldDelegate,
PronounceBtnCellDelegate
>{
    AVAudioPlayer *avPlayer;
    NSMutableArray *numberArr;
    NSString *theAnswer;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *cards;

@property (nonatomic, strong) NSMutableArray *wordArr;


@end

@implementation WordLibraryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    [self loadData];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"word_background"]];
    imgView.frame = self.view.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:imgView atIndex:0];
    
    [self.view addSubview:self.collectionView];
    [self setNavigation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    numberArr = [[NSMutableArray alloc] init];
    _wordArr = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HandlerBusiness ServiceWithApicode:ApiCodeGetWordLibrary Parameters:nil Success:^(id data , id msg){
       
        for (int i = 0; i < [data count]; i++) {
             [_wordArr addObject:data[i]];
        }
        
        // mock
        self.cards = [[NSMutableArray alloc] init];
        for (int i=0; i<_wordArr.count; i++) {
            [self.cards addObject:@(i)];
        }
        
        [_collectionView reloadData];
    }Failed:^(NSInteger code ,id errorMsg){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }Complete:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
//    
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
//                  @"american":@"[laɪk]",
//                  @"english":@"[laɪk]",
//                  @"voice":@"like",
//                  @"mean":@"vt.喜欢；想； 想要； 喜欢做\nadj.相似的； 相同的；\nn.相类似的人[事物]； 喜好； 爱好；种类，类型\nadv.和…一样;可能",
//                  };
//    tableDic2 = @{
//                  @"word":@"Down",
//                  @"american":@"[daʊn]",
//                  @"english":@"[daʊn]",
//                  @"voice":@"down",
//                  @"mean":@"adv.（坐、倒、躺）下； 向下； （表示范围或顺序的限度）下至；\nadj.向下的； 沮丧的； 计算机或计算机系统停机； （以…）落后于对手的\nn.使摔倒； 击落（敌机等）",
//                  };
//    tableDic3 = @{
//                  @"word":@"Wind",
//                  @"american":@"[wɪnd]",
//                  @"english":@"[wɪnd]",
//                  @"voice":@"wind",
//                  @"mean":@"n.风； 气流； 吞下的气； 管乐器\nvt.蜿蜒； 缠绕； 上发条； 使喘不过气来\nadj.管乐的；",
//                  };
//    tableDic4 = @{
//                  @"word":@"Sin",
//                  @"american":@"[sɪn]",
//                  @"english":@"[sɪn]",
//                  @"voice":@"sin",
//                  @"mean":@"n.违背宗教[道德原则]的恶行； 罪恶，罪孽； 过错，罪过； 愚蠢的事，可耻的事\nvi.犯罪，犯过错；\nvt.犯罪；",
//                  };
//    tableDic5 = @{
//                  @"word":@"Already",
//                  @"american":@"[ɔlˈrɛdi]",
//                  @"english":@"[ɔ:lˈredi]",
//                  @"voice":@"already",
//                  @"mean":@"adv.早已，已经； 先前；",
//                  };
//    tableDic6 = @{
//                  @"word":@"Free",
//                  @"american":@"[fri]",
//                  @"english":@"[fri:]",
//                  @"voice":@"free",
//                  @"mean":@"adj.自由的； 免费的； 免税的； 空闲的\nadv.免费地； 自由地，无拘束地； 一帆风顺地；\nvt.免除； 释放； 使自由； 解救",
//                  };
//    tableDic7 = @{
//                  @"word":@"Autumn",
//                  @"american":@"[ˈɔtəm]",
//                  @"english":@"[ˈɔ:təm]",
//                  @"voice":@"autumn",
//                  @"mean":@"n.秋； 秋天； 成熟期； 渐衰期\nadj.秋天的； 秋季的；",
//                  };
//    tableDic8 = @{
//                  @"word":@"Blue",
//                  @"american":@"[blu]",
//                  @"english":@"[blu:]",
//                  @"voice":@"blue",
//                  @"mean":@"n.蓝色； [复数]蓝色制服； 蓝颜料；\nadj.蓝色的； 沮丧的，忧郁的； 下流的；\nvi.变成蓝色，呈蓝色",
//                  };
//    tableDic9 = @{
//                  @"word":@"Never",
//                  @"american":@"[ˈnɛvɚ]",
//                  @"english":@"[ˈnevə(r)]",
//                  @"voice":@"never",
//                  @"mean":@"adv.从不，从来没有； 一点也不，决不； <口>不会…吧，没有； 不曾",
//                  };
//    tableDic10 = @{
//                   @"word":@"Dark",
//                   @"american":@"[dɑrk]",
//                   @"english":@"[dɑ:k]",
//                   @"voice":@"dark",
//                   @"mean":@"adj.黑暗的； 乌黑的； 忧郁的； 神秘的\nn.黑暗； 暗色； 暗处；",
//                   };
//    tableDic11 = @{
//                   @"word":@"Forget",
//                   @"american":@"[fərˈget]",
//                   @"english":@"[fəˈget]",
//                   @"voice":@"forget",
//                   @"mean":@"vt.忘记，忘却； 忽略，疏忽； 遗落； 忘掉\nvi.忘记； 忽视",
//                   };
//    tableDic12 = @{
//                   @"word":@"Red",
//                   @"american":@"[rɛd]",
//                   @"english":@"[red]",
//                   @"voice":@"red",
//                   @"mean":@"adj.红色的； （脸）涨红的； 烧红的； 红头发的\nn.红色； 红衣服； 红颜料； 红葡萄酒",
//                   };
//    tableDic13 = @{
//                   @"word":@"Right",
//                   @"american":@"[raɪt]",
//                   @"english":@"[raɪt]",
//                   @"voice":@"right",
//                   @"mean":@"adv.立刻，马上； 向右，右边； 恰当地； 一直\nadj.右方的； 正确的； 合适的； 好的，正常的\nn.正确，正当； 右边； 权利； 右手",
//                   };
//    tableDic14 = @{
//                   @"word":@"Easy",
//                   @"american":@"[ˈizi]",
//                   @"english":@"[ˈi:zi]",
//                   @"voice":@"easy",
//                   @"mean":@"adj.容易的； 舒适的； 宽裕的； 从容的\nadv.容易地； 不费力地； 悠闲地； 缓慢地\nvi.停止划桨（常用作命令）；",
//                   };
//    tableDic15 = @{
//                   @"word":@"Old",
//                   @"american":@"[oʊld]",
//                   @"english":@"[əʊld]",
//                   @"voice":@"old",
//                   @"mean":@"adj.老的； 古老的； 以前的； （用于指称被替代的东西）原来的\nn.古时；",
//                   };
//    tableDic16 = @{
//                   @"word":@"Know",
//                   @"american":@"[noʊ]",
//                   @"english":@"[nəʊ]",
//                   @"voice":@"know",
//                   @"mean":@"v.知道； 了解； 认识； 确信\nn.知情；",
//                   };
//    tableDic17 = @{
//                   @"word":@"Myself",
//                   @"american":@"[maɪˈsɛlf]",
//                   @"english":@"[maɪˈself]",
//                   @"voice":@"myself",
//                   @"mean":@"pron.我自己，亲自；",
//                   };
//    tableDic18 = @{
//                   @"word":@"Impossible",
//                   @"american":@"[ɪmˈpɑsəbl]",
//                   @"english":@"[ɪmˈpɒsəbl]",
//                   @"voice":@"impossible",
//                   @"mean":@"adj.不可能的，做不到的； 难以忍受的； 不会有的，不能相信的；\nn.不可能； 不可能的事",
//                   };
//    tableDic19 = @{
//                   @"word":@"Back",
//                   @"american":@"[bæk]",
//                   @"english":@"[bæk]",
//                   @"voice":@"back",
//                   @"mean":@"n.背，背部； 背面，反面； 后面，后部； （椅子等的）靠背\nvt.使后退； 支持； 加背书于； 下赌注于\nvi.后退； 倒退；",
//                   };
//
//    
//    [_wordArr addObject:tableDic1];
//    [_wordArr addObject:tableDic2];
//    [_wordArr addObject:tableDic3];
//    [_wordArr addObject:tableDic4];
//    [_wordArr addObject:tableDic5];
//    [_wordArr addObject:tableDic6];
//    [_wordArr addObject:tableDic7];
//    [_wordArr addObject:tableDic8];
//    [_wordArr addObject:tableDic9];
//    [_wordArr addObject:tableDic10];
//    [_wordArr addObject:tableDic11];
//    [_wordArr addObject:tableDic12];
//    [_wordArr addObject:tableDic13];
//    [_wordArr addObject:tableDic14];
//    [_wordArr addObject:tableDic15];
//    [_wordArr addObject:tableDic16];
//    [_wordArr addObject:tableDic17];
//    [_wordArr addObject:tableDic18];
//    [_wordArr addObject:tableDic19];

    
    
}

- (void)setNavigation{
    
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, 74.f)];
    UIImageView *returnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32, 12, 22)];
    UIImage *returnImage = [UIImage imageNamed:@"left_arrow_black"];
    returnImageView.image = returnImage;
    UILabel *returnBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 32, 60, 22)];
    returnBtnLabel.textColor = TEXT_COLOR_THIRDARY;
    returnBtnLabel.font = [UIFont boldSystemFontOfSize:18];
    if (self.wordType == 1) {
        returnBtnLabel.text = @"单词库";
    }
    else if(self.wordType == 2){
        returnBtnLabel.text = @"复习库";
    }
    [self.view addSubview:returnImageView];
    [self.view addSubview:returnBtnLabel];
    [self.view addSubview:returnBtn];

    [returnBtn addTarget:self action:@selector(backToView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WordLibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WordLibraryViewCollectionViewCellIdentity forIndexPath:indexPath];
    if (!cell) {
        cell = [[WordLibraryCollectionViewCell alloc] init];
    }
    
    cell.index = indexPath;
    cell.delegate = self;
    cell.tag = 100+indexPath.row;
    cell.WordMeaningLabel.numberOfLines = 0;
    cell.singleWordLabel.text = _wordArr[indexPath.row][@"wordName"];
    cell.EnglishPronounceLabel.text = _wordArr[indexPath.row][@"UKPronounce"];
    cell.AmericanPronounceLabel.text = _wordArr[indexPath.row][@"USPronounce"];
    cell.WordMeaningLabel.text = _wordArr[indexPath.row][@"mean"];
    cell.videoName = _wordArr[indexPath.row][@"USVoiceURL"];
    
    if (self.wordType == 1) {
        cell.cardView.backgroundColor = Rgb2UIColor(255, 255, 255, 0.8);
        cell.singleWordLabel.hidden = NO;
    }
    else{
        cell.cardView.backgroundColor = Rgb2UIColor(255, 255, 255, 1);
        cell.singleWordLabel.hidden = YES;
        
        //获取单词长度 并将长度存到 numberArr 数组里
        NSInteger numberOfWord = cell.singleWordLabel.text.length - 1;
        [numberArr addObject:[NSString stringWithFormat:@"%ld",(long)numberOfWord]];
        
        for (UIView *view in [cell.cardView subviews])
        {
            if (view.tag >= 1000) {
                [view removeFromSuperview];
            }
        }
        
        //输入框 隐藏了
        UITextField *wordField = [[UITextField alloc] initWithFrame:CGRectMake((280 - 22*numberOfWord)/2 + 8, 64, 22*numberOfWord, 32)];
        wordField.textColor = [UIColor whiteColor];
        wordField.font = [UIFont systemFontOfSize:30];
        wordField.tag = 1000 + indexPath.row;
        wordField.delegate = self;
        wordField.tintColor = [UIColor clearColor];
        wordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [cell.cardView addSubview:wordField];

        //显示的第一个单词
        UILabel *firstWordLabel = [[UILabel alloc] initWithFrame:CGRectMake((280 - 22*numberOfWord)/2 - 15, 64, 30, 32)];
        firstWordLabel.textColor = THEME_COLOR;
        firstWordLabel.tag = 2000 + indexPath.row;
        firstWordLabel.font = [UIFont systemFontOfSize:30];
        firstWordLabel.text = [NSString stringWithFormat:@"%@",[cell.singleWordLabel.text substringToIndex:1]];
        [cell.cardView addSubview:firstWordLabel];
        
        //单词空格和下划线
        for(int a = 0; a < numberOfWord; a++){
            UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake((280 - 25*numberOfWord)/2 - 12 + 25*(a+1), 64, 25, 32)];
            wordLabel.textColor = THEME_COLOR;
            wordLabel.font = [UIFont systemFontOfSize:28];
            wordLabel.tag = wordField.tag*100 + a;
            wordLabel.textAlignment = NSTextAlignmentCenter;
            [cell.cardView addSubview:wordLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(3, 30, 19, 2)];
            lineView.backgroundColor = THEME_COLOR;
            [wordLabel addSubview:lineView];
        }
        
    }
    
    return cell;
}

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.collectionView.scrollEnabled = NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.collectionView.scrollEnabled = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //addTarget
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //判断操作是否是删除 string.length = 0即为删除
    if (string.length == 0) {
        UILabel *label = (UILabel *)[self.view viewWithTag:textField.tag*100 + textField.text.length-1];
        label.text = string;
    }
    else{
        UILabel *label = (UILabel *)[self.view viewWithTag:textField.tag*100 + textField.text.length];
        label.text = string;
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    NSInteger  number = [numberArr[textField.tag - 1000] integerValue];
    
    if (textField.text.length > number) {
        textField.text = [textField.text substringToIndex:number];
    }
    if (textField.text.length == number) {
        UITextField *field = (UITextField *)[self.view viewWithTag:textField.tag];
        field.returnKeyType = UIReturnKeyDone;
        theAnswer = textField.text;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    //获取正确答案
    NSString *rightAnswer = [_wordArr[textField.tag - 1000][@"wordName"] substringFromIndex:1];
    
    //判断答案
    if (rightAnswer == theAnswer) {
        NSLog(@"success");
        [self alertWithMessage:@"拼写正确o(∩_∩)o"];
    }
    else{
        NSLog(@"fail");
        [self alertWithMessage:@"拼写错误o(╯□╰)o"];
    }
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中---%ld", indexPath.row);
}


#pragma mark - Getter 

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = ({
            UICollectionView *collect = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[[WordLibraryCollectionViewFlowLayout alloc] init]];
            collect.dataSource = self;
            collect.delegate   = self;
            collect.backgroundColor = [UIColor clearColor];
            collect.showsHorizontalScrollIndicator = NO;
            [collect registerNib:[UINib nibWithNibName:@"WordLibraryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WordLibraryViewCollectionViewCellIdentity];
            collect;
        });
    }
    return _collectionView;
}

#pragma mark - PronounceBtnCellDelegate

- (void)AmericanCellDelegate:(NSIndexPath *)index withVideoName:(NSString *)videoName{
    NSLog(@"%@",index);
    //获取歌曲路径
    NSString *path = [[NSBundle mainBundle]pathForResource:videoName ofType:@".mp3"];
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
}

- (void)BritishBtnCellDelegate:(NSIndexPath *)index withVideoName:(NSString *)videoName{
    NSLog(@"aaaaaa%@",index);
    //获取歌曲路径
    NSString *path = [[NSBundle mainBundle]pathForResource:videoName ofType:@".mp3"];
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
}

#pragma mark setButtonAction
- (void)backToView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_DISPLAYNAME message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


@end
