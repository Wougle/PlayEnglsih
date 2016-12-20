//
//  PESubmitViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/12/5.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PESubmitViewController.h"

@interface PESubmitViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSString *noticeContent;
}

@property (weak, nonatomic) IBOutlet UIImageView *subImageView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation PESubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发表动态";
    
    [_addBtn addTarget:self action:@selector(imagePickerControllerSelect) forControlEvents:UIControlEventTouchUpInside];
    
    _subBtn.layer.cornerRadius = 3.0f;
    _subBtn.layer.masksToBounds = YES;
    [_subBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTitleTextView];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)submit{
    
    if (noticeContent.length == 0) {
        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"您还没填写你的动态呢" preferredStyle:UIAlertControllerStyleAlert];
        [alterController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        }]];
        [self presentViewController:alterController animated:YES completion:nil];
    }
    else{
        
        NSDate *detaildate=[NSDate date];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *timeString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: detaildate]];
        
        NSDictionary *tableDic = [[NSMutableDictionary alloc] init];
        tableDic = @{
                     @"commID":[NSString stringWithFormat:@"%d",_commIdLocal],
                     @"nickName":[UserDefaultsUtils valueWithKey:@"nickName"],
                     @"time":timeString,
                     @"headImage":[UserDefaultsUtils valueWithKey:@"headImage"],
                     @"isFollow":@"0",
                     @"text":noticeContent,
                     @"video":@"-1",
                     @"image":@"-1",
                     @"reply":@"0",
                     @"like":@"0",
                     @"isLike":@"1",
                     };
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HandlerBusiness ServiceWithApicode:ApiCodeSubmitCommunity Parameters:tableDic Success:^(id data , id msg){
            DBG(@"发表成功");
            
        }Failed:^(NSInteger code ,id errorMsg){
            
            UIAlertController *alterController = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"发表成功！" preferredStyle:UIAlertControllerStyleAlert];
            [alterController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }]];
            [self presentViewController:alterController animated:YES completion:nil];
            
           // [MBProgressHUD hideHUDForView:self.view animated:YES];
        }Complete:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textView
- (void)setTitleTextView{
    titleTextView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(20, 66, SCREEN_WIDTH - 40, 180)];
    [self.view addSubview:titleTextView];
    titleTextView.delegate = self;
    titleTextView.backgroundColor = [UIColor whiteColor];
    titleTextView.placeholder = @"快发表你的动态吧";
    titleTextView.placeholderColor=TEXT_COLOR_SECONDARY;
    titleTextView.font = [UIFont systemFontOfSize:15];
    
    //隐藏滚动条
    titleTextView.showsVerticalScrollIndicator = false;
    titleTextView.showsHorizontalScrollIndicator = false;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >= 140&&textView==titleTextView)
    {
        //控制输入文本的长度
        return  NO;
    }
    if ([text isEqualToString:@"\n"]&&textView==titleTextView) {
        //禁止输入换行
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView ==titleTextView) {
        noticeContent = textView.text;
    }
    [titleTextView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [titleTextView  resignFirstResponder];
}

#pragma mark - imagePicker
//配图选取
- (void)imagePickerControllerSelect
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak PESubmitViewController *weakSelf = self;
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //相机权限受限
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:ALERT_TITLE message:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机",ALERT_TITLE] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            _imagePicker.delegate = weakSelf;
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            _imagePicker.mediaTypes = mediaTypes;
            _imagePicker.allowsEditing=YES;
            [weakSelf presentViewController:_imagePicker
                                   animated:YES
                                 completion:^(void){
                                 }];
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _imagePicker = [[UIImagePickerController alloc]init];
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            _imagePicker.mediaTypes = mediaTypes;
            _imagePicker.delegate = weakSelf;
            _imagePicker.allowsEditing=YES;
            [weakSelf presentViewController:_imagePicker
                                   animated:YES
                                 completion:^(void){
                                 }];
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获得编辑过的图片
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    CGSize size = CGSizeMake(200, 200);
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    [_subImageView setImage: scaledImage];
    
    
    //NSData *data = UIImageJPEGRepresentation(scaledImage, 1.0f);
    //_headImgBase64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //isImageChange = 1;
}


@end
