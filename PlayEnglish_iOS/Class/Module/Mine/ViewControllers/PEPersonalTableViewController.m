//
//  PEPersonalTableViewController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 2016/11/17.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "PEPersonalTableViewController.h"
#import "PersonalDateTableViewCell.h"

static NSString *const kPersonalDateTableViewCell = @"kPersonalDateTableViewCell";


@interface PEPersonalTableViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>{
    NSInteger _sexId;
    NSString *nickStr;
    NSString *sexStr;
    NSString *cityStr;
    NSString *phoneStr;
    NSString *signStr;
}

@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSArray *placeHolderArr;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (nonatomic,strong) UITextField *textField;//用于隐藏键盘
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation PEPersonalTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _titleArr = @[@"昵称",@"性别",@"所在城市",@"手机号码",@"个签"];
    _placeHolderArr = @[[UserDefaultsUtils valueWithKey:@"nickName"],[UserDefaultsUtils valueWithKey:@"sex"],[UserDefaultsUtils valueWithKey:@"city"],[UserDefaultsUtils valueWithKey:@"phone"],[UserDefaultsUtils valueWithKey:@"sign"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的资料";
    
    [self setNavRightBtn];
    
    [self prepareView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
}

-(void)setNavRightBtn{
    UIView *rightNavgationBarView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80 - 12, 5, 80, 34)];
    UIButton *approveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 34)];
    [approveBtn setBackgroundColor:LINE_COLOR];
    approveBtn.layer.cornerRadius=17;
    approveBtn.tintColor = TEXT_COLOR_SECONDARY;
    [approveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [approveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [approveBtn addTarget:self action:@selector(toApprove) forControlEvents:UIControlEventTouchUpInside];
    [rightNavgationBarView addSubview:approveBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavgationBarView];
}

- (void)prepareView{
    
    self.tableView.backgroundColor = Rgb2UIColor(243, 243, 243, 1.0);
    
    UIView *hdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130.f)];
    hdView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 129, SCREEN_WIDTH, 1.f)];
    lineView.backgroundColor = Rgb2UIColor(228, 227, 229, 1.0);
    [hdView addSubview:lineView];
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 10, 100, 100)];
    [imageBtn addTarget:self action:@selector(imagePickerControllerSelect) forControlEvents:UIControlEventTouchUpInside];
    
    
    _iconImageView = [[UIImageView alloc] init];
    
    _iconImageView.frame = CGRectMake((SCREEN_WIDTH - 100)/2, 10, 100, 100);
    _iconImageView.layer.cornerRadius = 50.f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderWidth = 3.0f;
    _iconImageView.layer.borderColor = THEME_COLOR.CGColor;
    _iconImageView.image = [UIImage imageNamed:[UserDefaultsUtils valueWithKey:@"headImage"]];
    
    [hdView addSubview:_iconImageView];
    [hdView addSubview:imageBtn];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = hdView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonalDateTableViewCell];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalDateTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.titleLabel.text = _titleArr[indexPath.row];
    cell.detailTextField.placeholder = _placeHolderArr[indexPath.row];
    cell.detailTextField.delegate = self;
    cell.detailTextField.tag = 1000 + indexPath.row;
    cell.blackBtn.hidden = YES;
    if (indexPath.row == 1) {
        cell.blackBtn.hidden = NO;
        [cell.blackBtn addTarget:self action:@selector(sexSelect:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 1000) {
        nickStr = textField.text;
        [self sexSelect:nil];
    }
    else if (textField.tag == 1002){
        cityStr = textField.text;
        UITextField *field = (UITextField *)[self.view viewWithTag:textField.tag+1];
        [field becomeFirstResponder];
    }
    else if (textField.tag == 1003){
        phoneStr = textField.text;
        UITextField *field = (UITextField *)[self.view viewWithTag:textField.tag+1];
        [field becomeFirstResponder];
    }
    else if (textField.tag == 1004){
        signStr = textField.text;
        [textField resignFirstResponder];;
    }
    
    
    return true;
}

- (void)hideKeyboard{
    for (int i = 1001; i <= 1005; i++) {
        self.textField = (UITextField *)[self.view viewWithTag:i];
        [self.textField resignFirstResponder];
    }
}

- (void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 11) {
                textField.text = [toBeString substringToIndex:11];
            }
        }

    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 11) {
            textField.text = [toBeString substringToIndex:11];
        }  
    }
}

//防止联想输入超过输入最大值
- (void)textFieldDidChange:(UITextField *)textField
{
    
    for (int i = 1001; i <= 1005; i++) {
        self.textField = (UITextField *)[self.view viewWithTag:i];
        switch (i) {
            case 1001:
                if (textField == self.textField) {
                    if (textField.text.length > 11) {
                        textField.text = [textField.text substringToIndex:11];
                    }
                }
                break;
            default:
                break;
        }
    }
}
#pragma mark --收起键盘

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    [self.view endEditing:YES];
    
}

#pragma mark - 各种选择
- (void)sexSelect:(id)sender{

    [self hideKeyboard];
    
    self.textField = (UITextField *)[self.view viewWithTag:1001];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.textField.text = @"男";
        sexStr = self.textField.text;
        _sexId = 1;
        UITextField *field = (UITextField *)[self.view viewWithTag:1002];
        [field becomeFirstResponder];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.textField.text = @"女";
        sexStr = self.textField.text;
        _sexId = 2;
        UITextField *field = (UITextField *)[self.view viewWithTag:1002];
        [field becomeFirstResponder];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


#pragma mark - imagePicker
//头像选取
- (void)imagePickerControllerSelect
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak PEPersonalTableViewController *weakSelf = self;
    
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
    [_iconImageView setImage: scaledImage];
    
    
    //NSData *data = UIImageJPEGRepresentation(scaledImage, 1.0f);
    //_headImgBase64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //isImageChange = 1;
}

#pragma mark - button action

- (void)toApprove{
    if (nickStr.length == 0) {
        nickStr = [UserDefaultsUtils valueWithKey:@"nickName"];
    }
    if (sexStr.length == 0) {
        sexStr = [UserDefaultsUtils valueWithKey:@"sex"];
    }
    if (cityStr.length == 0) {
        cityStr = [UserDefaultsUtils valueWithKey:@"city"];
    }
    if (phoneStr.length == 0) {
        phoneStr = [UserDefaultsUtils valueWithKey:@"phone"];
    }
    if (signStr.length == 0) {
        signStr = [UserDefaultsUtils valueWithKey:@"sign"];
    }
    
    NSDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters = @{
                 @"userID":[UserDefaultsUtils valueWithKey:@"userID"],
                 @"headImage":[UserDefaultsUtils valueWithKey:@"headImage"],
                 @"userName":nickStr,
                 @"userSex":sexStr,
                 @"userAddress":cityStr,
                 @"userPhone":phoneStr,
                 @"userSign":signStr,
                 };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HandlerBusiness ServiceWithApicode:ApiCodeChangeUserData Parameters:parameters Success:^(id data , id msg){
        
        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"修改成功！" preferredStyle:UIAlertControllerStyleAlert];
        [alterController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [self presentViewController:alterController animated:YES completion:nil];
        
    }Failed:^(NSInteger code ,id errorMsg){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }Complete:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

@end
