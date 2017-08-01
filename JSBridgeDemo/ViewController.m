//
//  ViewController.m
//  JSBridgeDemo
//
//  Created by gomeguomingyue on 2017/4/27.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//  

#import "ViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "WebViewJavascriptBridge.h"


#import "GMSystemAuthorizationTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIDevice+tools.h"

#import <AdSupport/AdSupport.h>

//通讯录
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


//
#import "TQBPreviewController.h"

#import "SXAddressBookManager.h"
#import "MYFDefines.h"

#import "LocationTools.h"
#import "TestViewController.h"
#import "constant.h"
#import "defines.h"
#import "UIImage+Rotate.h"

#import "TQBNewWebViewController.h"
#import "LoginOutViewController.h"


@interface ViewController ()< UIWebViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate , LoginOutDelegate  >

@property WebViewJavascriptBridge * bridge;

@property (nonatomic, strong) UIWebView* webView;

@property (nonatomic, copy) WVJBResponseCallback responseCallback;//照片
@property (nonatomic, copy) WVJBResponseCallback locationResponseCallback;//定位
@property (nonatomic, strong) WVJBResponseCallback phoneCallBack;//拨打电话
@property (nonatomic, strong) WVJBResponseCallback pasteboardCallBack; //获取粘贴版
@property (nonatomic, strong) WVJBResponseCallback addressBookCallBack; //获取通讯录
@property (nonatomic, strong) WVJBResponseCallback shareCallBack; //分享回调
@property (nonatomic, strong) WVJBResponseCallback previewImageCallBack; // 预览回调
@property (nonatomic, strong) WVJBResponseCallback setNavigationBarTitleCallBack; //设置导航栏标题
@property (nonatomic, strong) WVJBResponseCallback setNavigationBarColorCallBack; //设置导航栏颜色
@property (nonatomic, strong) WVJBResponseCallback showNavigationBarCallBack; //显示导航栏
@property (nonatomic, strong) WVJBResponseCallback hideNavigationBarCallBack; //隐藏导航栏

@property(nonatomic,strong)NSArray<SXPersonInfoEntity *>*personEntityArray;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"JavaScriptBridge";
    //  = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    
    //初始化progressView
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, 2.0f)];
    self.progressView.backgroundColor = [UIColor blueColor];
    self.progressView.transform = CGAffineTransformMakeScale(1.0, 1.5f);
    [self.view addSubview:self.progressView];
    
    //清理缓存
    [self deleteWebCache];
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"js" ofType:@"js"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    NSString *js =[NSString stringWithContentsOfURL:baseURL encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //初始化环境和相关组件
    if (_bridge) {
        return;
    }
    /*
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
     */
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    //self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    //self.webView.navigationDelegate = self;
    self.webView.delegate = self;
    
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.webView];
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    //注册方法
    __weak typeof(self) weakSelf = self;
    
    [_bridge registerHandler:@"chooseImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"call back gome_getphoto:%@",data);
        weakSelf.responseCallback = responseCallback;
        
        ///album 从相册选图，camera 使用相机，无数据/其他的时候 二者都允许
        NSString *source = [data objectForKey:@"sourceType"];
        if ([source isEqualToString:@"album"]) {
            [self photographAction];

        }else  if ([source isEqualToString:@"camera"]) {
            [self cameraAction];
            
        }else{
            //初始化AlertView
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"相机",nil];
            //通过给定标题添加按钮
            [alert addButtonWithTitle:@"相册"];
            //显示AlertView
            [alert show];
        }
        
    }];
    // 预览一组图片
    
    [_bridge registerHandler:@"previewImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary * info = (NSDictionary * )data;
        
        NSArray * array  = [info objectForKey:@"urls"];
        weakSelf.shareCallBack  = self.previewImageCallBack;
        TQBPreviewController  *vc = [[TQBPreviewController alloc] init];
        vc.imageArray = array;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [_bridge registerHandler:@"makePhoneCall" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"call back gome_getphoto:%@",data);
        
        //直接从data中解析
        
        NSDictionary * dict = (NSDictionary *)data;
        NSString * phone = [dict objectForKey:@"phoneNumber"];

        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView  *  callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        weakSelf.responseCallback = _phoneCallBack;

//        [weakSelf makePhoneCall];
    }];
    
    //设置系统粘贴版内容
    [_bridge registerHandler:@"setClipboardData" handler:^(id data, WVJBResponseCallback responseCallback) {
        //直接从data中解析
        NSString  * string = (NSString *)data;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = string;
        NSLog(@"%@",pasteboard.string);
    }];
    

  //  获取系统剪贴板内容
    [_bridge registerHandler:@"getClipboardData" handler:^(id data, WVJBResponseCallback responseCallback) {

        //直接从data中解析
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        responseCallback( [self DataTOjsonString:pasteboard.string]);
    }];
    
    //获取经纬度
    
    [_bridge registerHandler:@"getLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"call back gome_getgps:%@",data);
        weakSelf.locationResponseCallback = responseCallback;
        [weakSelf locationAction];
    }];

    
    // 获取通讯录功能
    [_bridge registerHandler:@"getAddressBook" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.addressBookCallBack = responseCallback;
        [weakSelf getAllAddressBookInformation];
        
    }];
    
//    [self getAllAddressBookInformation];
    
    // 获取通讯录功能 (获取一个通讯录)
    
    [_bridge registerHandler:@"getContact" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.addressBookCallBack = responseCallback;
        [weakSelf getAddressBookInformation];
        
    }];
    

    //登录
    [_bridge registerHandler:@"login" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        LoginOutViewController *vc = [LoginOutViewController new];
        vc.delegate = self;
        [self presentViewController:vc animated:1 completion:^{
            
        }];
        
    }];
    
    //注销
    [_bridge registerHandler:@"logout" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        LoginOutViewController *vc = [LoginOutViewController new];
        vc.delegate = self;
        [self presentViewController:vc animated:1 completion:^{
            
        }];
        
    }];
    //获取设备选型
    [_bridge registerHandler:@"getDeviceInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        [weakSelf getDeviceInfo];
        
    }];
    //获取设备选型
    [_bridge registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.responseCallback  = responseCallback;
        [weakSelf getUserInfo];
        
    }];
    
    //获取分享信息
    [_bridge registerHandler:@"shareInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.shareCallBack  = self.shareCallBack;

    }];
    
  
    

    //获取ios
    
    [self setNavigationBar];
    
    //加载页面
    [self loadExamplePage:self.webView];
}
-(void)getUserInfo
{
    //app软件
    NSDictionary *appInfoDict = [[NSBundle mainBundle] infoDictionary];
    NSString*  appVersion =[NSString stringWithFormat:@"%@",  [appInfoDict objectForKey:@"CFBundleShortVersionString"]  ];
    
    NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;

    
    NSDictionary *info =
  @{@"accesstoken":@"data.accesstoken demo 无数据",
    @"session_id":@"session_id demo 无数据",
    @"registration_id":@"registration_id demo 无数据",
    @"deviceToken":@"deviceToken demo 无数据",

    
    
    @"font":@"2",
    @"channel_id":@"0",///AppStore
    @"city_id":@"123",//假如是成都
    @"appver":appVersion,
    @"imei":idfa
    
                           
                           };
    
    self.responseCallback([self DataTOjsonString:info]);
    
    
}
-(void)getDeviceInfo
{
    NSDictionary *info = [self getSystemInfo:nil block:nil];
    self.responseCallback([self DataTOjsonString:info]);
    
    
}

//
///获取系统信息
-(NSMutableDictionary*)getSystemInfo:(BOOL)flag block:(void (^)(NSMutableDictionary*))block
{
    static  NSMutableDictionary *staticInfo ;
    if(staticInfo) return staticInfo;
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary ];
    //系统
    NSString *systemName = [UIDevice currentDevice].systemName;
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSString *freeDiskSpaceInMB = [UIDevice freeDiskSpaceInMB];
    
    
    NSString *idfa = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    
    
    //硬件
    
    NSString *platform = [UIDevice platformString];
    NSString *screenSize = NSStringFromCGSize([UIScreen mainScreen].bounds.size);
    //    NSString *screenScale = @([UIScreen mainScreen].scale).stringValue;
    
    
    NSString *CPUType = [UIDevice getCPUTypeString];
    NSString *batteryLevel = @([UIDevice currentDevice].batteryLevel).stringValue;
    
    
    //网络
    NSString *deviceSSID = [UIDevice getDeviceSSID];
    NSString *macAddress = [UIDevice getMacAddress];
    NSString *SIMcarrier = [UIDevice getSIMcarrier];
    
    //2/3/4g
    NSString *netWorkType = [UIDevice getNetWorkType];
    
    
    //app软件
    NSDictionary *appInfoDict = [[NSBundle mainBundle] infoDictionary];
    NSString*  appVersion =[NSString stringWithFormat:@"%@",  [appInfoDict objectForKey:@"CFBundleShortVersionString"]  ];
    
    
    
    
    
    ///系统——
    [info setObject:systemName forKey:@"system_name"];
    [info setObject:systemVersion forKey:@"osVer"];
    
    
    
    
    
    ///硬件——
    [info setObject:platform forKey:@"platform"];
    
    
    ///网络——
    if(deviceSSID)
        [info setObject:deviceSSID  forKey:@"wifissid"];
    if(macAddress)
        [info setObject:macAddress  forKey:@"macAddress"];
    if(SIMcarrier)
        [info setObject:SIMcarrier  forKey:@"SIMcarrier"];
    if(netWorkType)
        [info setObject:netWorkType  forKey:@"netWorkType"];
    
    
    
    
    [info setObject:idfa forKey:@"imei"];
    
    [info setObject:appVersion forKey:@"appVer"];

   
    
    
    
    
    staticInfo = info;
    return info;
    
}
-(void)setNavigationBar
{
    
    __weak typeof(self) weakSelf = self;

    [_bridge registerHandler:@"setNavigationBarTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary * info = (NSDictionary * )data;
        
        weakSelf.title = [info objectForKey:@"title"];

        weakSelf.shareCallBack  = self.setNavigationBarTitleCallBack;

    }];

    [_bridge registerHandler:@"setNavigationBarColor" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary * info = (NSDictionary * )data;
        NSString * frontColor = [info objectForKey:@"frontColor"];
        NSString * backgroundColor = [info objectForKey:@"backgroundColor"];
        [weakSelf.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[self colorWithHexString:frontColor alpha:1]}] ;
        
        weakSelf.navigationController.navigationBar.barTintColor = [self colorWithHexString:backgroundColor alpha:1];


        weakSelf.shareCallBack  = self.setNavigationBarColorCallBack;
        
    }];
    
    [_bridge registerHandler:@"showNavigationBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.navigationController.navigationBarHidden = NO;
        weakSelf.shareCallBack  = self.showNavigationBarCallBack;
        
    }];
    

    [_bridge registerHandler:@"hideNavigationBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        weakSelf.navigationController.navigationBarHidden = YES;
        weakSelf.shareCallBack  = self.hideNavigationBarCallBack;
        
    }];
    
    [self setWeb];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 20, 15, 15);
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
}

-(void)setWeb
{
    
    __weak typeof(self) weakSelf = self;
    
    [_bridge registerHandler:@"navigateTo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary * info = (NSDictionary * )data;

        NSString * url = [info objectForKey:@"url"];
        
        
//        NSRange range = [url rangeOfString:@"taoqian123"];
        
//        if(range.location != NSNotFound)
        
//        {

            TQBNewWebViewController * vc  = [[TQBNewWebViewController alloc] init];
            vc.url = url;
            [weakSelf.navigationController pushViewController:vc animated:YES];
    

//        }else{
        
            
//        }
    
    
    }];
    
    
    [_bridge registerHandler:@"redirectTo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary * info = (NSDictionary * )data;
        
        NSString * url = [info objectForKey:@"url"];
        
        
//        NSRange range = [url rangeOfString:@"taoqian123"];
//        
//        if(range.location != NSNotFound)
//            
//        {
        
            NSString* htmlPath = url;
            NSURL *baseURL = [NSURL URLWithString:htmlPath];
            [weakSelf.webView loadRequest:[NSMutableURLRequest requestWithURL:baseURL]];
//            
//        }else{
//            
//            
//          
//            
//        }
    }];
    
    [_bridge registerHandler:@"navigateBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        
//        NSDictionary * info = (NSDictionary * )data;
        
//        NSString * url = [info objectForKey:@"url"];
        
        
//        NSRange range = [url rangeOfString:@"taoqian123"];
//        
//        if(range.location != NSNotFound)
//            
//        {
        
        [weakSelf back:self.navigationItem.leftBarButtonItem];
            
//        }else{
//            
//            
//            
//            
//        }
        
    }];
    
}

//用苹果自带的返回键按钮处理如下(自定义的返回按钮)
- (void)back:(UIBarButtonItem *)btn
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

- (void)loadExamplePage:(UIWebView*)webView {
    
    NSLog(@"baseUrl = %@", baseUrl);
    NSString* htmlPath = baseUrl;
    NSURL *baseURL = [NSURL URLWithString:htmlPath];
    [webView loadRequest:[NSMutableURLRequest requestWithURL:baseURL]];
    
}

-(void)getAllAddressBookInformation
{

    SXAddressBookAuthStatus status = [[SXAddressBookManager manager]getAuthStatus];
    if (status == kSXAddressBookAuthStatusNotDetermined) {
        
        [[SXAddressBookManager manager]askUserWithSuccess:^{
            self.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
        } failure:^{
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"淘钱宝未获取通讯录权限" message:@"请在系统设置中允许“淘钱宝”访问相机\n 设置-> 隐私-> 相机 -> 淘钱宝" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                        [[UIApplication sharedApplication] openURL:url];
                                    }
                                }];
                                [alertViewController addAction:cancelAction];
                                [alertViewController addAction:confirmAction];
                                [self presentViewController:alertViewController animated:YES completion:nil];
        }];
        
    }else if (status == kSXAddressBookAuthStatusAuthorized){
        
        self.personEntityArray = [[SXAddressBookManager manager]getPersonInfoArray];
        
        NSMutableArray *data = [NSMutableArray array];
        
        for (NSInteger i = 0;  i < self.personEntityArray.count; i++) {
            
            SXPersonInfoEntity * person = [self.personEntityArray objectAtIndex:i];
            NSArray * phones = [person.phoneNumber componentsSeparatedByString:@"."];
            [data addObject:@{@"username":person.fullname,@"phones":phones}];
            
        }
        _addressBookCallBack([self DataTOjsonString:data]);
        
    }else{
        NSLog(@"没有权限");
    }

    
//    [GMSystemAuthorizationTool checkAddressBookAuthorization:^(bool isAuthorized, ABAuthorizationStatus authorStatus) {
//        
//        if (isAuthorized) {
//            
//            
//        } else {
//        
//            // 请求授权
//            ABAddressBookRef addressBookRef = ABAddressBookCreate();
//            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
//                if (granted) { // 授权成功
//                    
//                } else {  // 授权失败
//                    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"淘钱宝未获取通讯录权限" message:@"请在系统设置中允许“淘钱宝”访问相机\n 设置-> 隐私-> 相机 -> 淘钱宝" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                            [[UIApplication sharedApplication] openURL:url];
//                        }
//                    }];
//                    [alertViewController addAction:cancelAction];
//                    [alertViewController addAction:confirmAction];
//                    [self presentViewController:alertViewController animated:YES completion:nil];
//                    
//                }
//            });
//            
//        }
//        
//    }];
//
}

-(void)getAddressBookInformation{
    
    
    [GMSystemAuthorizationTool checkAddressBookAuthorization:^(bool isAuthorized, ABAuthorizationStatus authorStatus) {
       
        if (isAuthorized) {

            
            [[SXAddressBookManager manager]presentPageOnTarget:self chooseAction:^(SXPersonInfoEntity *person) {
                
                
                if (person.phoneNumber.length) {
                    
                }
                
                NSArray * phones = [person.phoneNumber componentsSeparatedByString:@"."];
                NSArray * arrary = [NSArray arrayWithObjects:@{@"username":person.fullname,@"phones":phones}, nil];
                
                _addressBookCallBack([self DataTOjsonString:arrary]);

            }];
        } else {
            
            // 请求授权
            ABAddressBookRef addressBookRef = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) { // 授权成功
                    
                } else {  // 授权失败
                    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"淘钱宝未获取通讯录权限" message:@"请在系统设置中允许“淘钱宝”访问相机\n 设置-> 隐私-> 相机 -> 淘钱宝" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }];
                    [alertViewController addAction:cancelAction];
                    [alertViewController addAction:confirmAction];
                    [self presentViewController:alertViewController animated:YES completion:nil];
                }
            });
            
        }

    }];
}


#pragma mark - events handle
-(void)photographAction
{

    //打开相册
    [GMSystemAuthorizationTool checkPhotographAlbumAuthorization:^(bool isAuthorized) {
        if (isAuthorized) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
                    pickerViewController.delegate = self;
                    pickerViewController.allowsEditing = NO;
                    pickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self presentViewController:pickerViewController animated:YES completion:nil];
                });
            }else{
                NSDictionary * dict = @{@"code":@"-1",@"msg":@"设备不支持相册"};
                self.responseCallback([self DictTOjsonString:dict]);
                
            }
        } else {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"淘钱宝未获取相册权限" message:@"请在系统设置中允许“淘钱宝”访问相册\n 设置-> 隐私-> 相册 -> 淘钱宝" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertViewController addAction:cancelAction];
            [alertViewController addAction:confirmAction];
            [self presentViewController:alertViewController animated:YES completion:nil];
        }
    }];
    
    
}


-(void)cameraAction
{
    //打开相机
    [GMSystemAuthorizationTool checkCameraAuthorization:^(bool isAuthorized, AVAuthorizationStatus authorStatus) {
        if (isAuthorized) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
                    pickerViewController.delegate = self;
                    pickerViewController.allowsEditing = NO;
                    pickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self presentViewController:pickerViewController animated:YES completion:nil];
                });
                
            }else{
                NSDictionary * dict = @{@"code":@"-1",@"msg":@"设备不支持相机"};
                self.responseCallback([self DictTOjsonString:dict]);
                
            }
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"淘钱宝获取x相机权限" message:@"请在系统设置中允许“淘钱宝”访问相机\n 设置-> 隐私-> 相册 -> 淘钱宝" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *concelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:concelAction];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];

    
   
}

-(void)locationAction
{
    NSLog(@"locationAction");
    //打开相册
    [GMSystemAuthorizationTool checkLocationAuthorization:^(bool isAuthorized, CLAuthorizationStatus status) {
        if (isAuthorized) {
            [[LocationTools sharedInstance] getCurrentLocation:^(CLLocation *location, CLPlacemark *pl, NSString *error, BOOL loading) {
                if (pl.locality.length > 0) {
            
                    
                    NSString * latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
                    
                    NSString * longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
                    
                    NSString *sheng  = pl.administrativeArea;
                    NSString *shi  = pl.locality;
                    NSString *qu  = pl.subLocality;
                    NSString *street  = pl.name;

                    NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@",sheng,shi,qu,street];
                    
                    NSDictionary *info = @{@"latitude":latitude,@"longitude":longitude,@"address":address,
                                           @"addressDetail":@{@"province":sheng,@"city":shi,@"region":qu,@"street":street}};
                    
                    self.locationResponseCallback([self DataTOjsonString:info]);
                    
                }
            }];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"淘钱宝获取位置权限" message:@"请在系统设置中允许“淘钱宝”访问位置\n 设置-> 隐私-> 位置 -> 淘钱宝" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *concelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:concelAction];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:confirmAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];

  
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = [[UIImage alloc] init];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        if (picker.allowsEditing == YES) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        NSLog(@"是竖屏");
    } else {
        NSLog(@"不是竖屏");
    }
    NSLog(@"image.size = %@",[NSValue valueWithCGSize:image.size]);
    [self handlePicture:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - hundle picture
-(void)handlePicture:(UIImage *)image
{
    image = [image fixOrientation:image];
    image = [image rotate:UIImageOrientationLeft];
//    image = [image imageRotatedByDegrees:0.0f];
    NSLog(@"image.size1 = %@",[NSValue valueWithCGSize:image.size]);
    NSData *data = UIImageJPEGRepresentation(image, 0.1f);
    NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"base64String = %@",base64String);
    
    self.responseCallback([self DataTOjsonString:base64String]);
}

#pragma mark - compress iamge
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    if (newSize.width == 0) {
        newSize = image.size;
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - WKNavigationDelegate
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    return YES;
//}
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    NSLog(@"webViewDidStartLoad");
//    self.progressView.hidden = NO;
//    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//    [self.view bringSubviewToFront:self.progressView];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSLog(@"webViewDidFinishLoad");
//
//}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    NSLog(@"webViewDidFail");
//    self.progressView.hidden = YES;
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        self.progressView.progress = self.webView.estimatedProgress;
//        if (self.progressView.progress == 1) {
//            __weak typeof(self) weakSelf = self;
//            [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
//            } completion:^(BOOL finished) {
//                weakSelf.progressView.hidden = YES;
//            }];
//        }
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

#pragma mark - delete web cache
-(void)deleteWebCache
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        NSArray *types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@",cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}
#pragma mark - loginout delegate
-(void)didLogout:(id)data
{
    NSDictionary * dict = @{@"code":@"0",@"msg":@"sucess",@"data":data?:@""};
    self.responseCallback([self DictTOjsonString:dict]);
    
}
-(void)didLogin:(id)data
{
    NSDictionary * dict = @{@"code":@"0",@"msg":@"sucess",@"data":data?:@""};
    self.responseCallback([self DictTOjsonString:dict]);
    
}
-(void)didRecevieMsg:(NSString *)msg
{
    NSDictionary * dict = @{@"code":@"-1",@"msg":msg?:@"error"};
    self.responseCallback([self DictTOjsonString:dict]);
    
}
#pragma mark -- A
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld,",(long)buttonIndex);

    if (buttonIndex == 1) {

        [self photographAction];

    }else if (buttonIndex  == 2){
        
        [self cameraAction];

    }
    
}


#pragma mark -- ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    //电话号码
    CFStringRef telValue = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    //读取firstname
    //获取个人名字（可以通过以下两个方法获取名字，第一种是姓、名；第二种是通过全名）。
    //第一中方法
    //    CFTypeRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //    CFTypeRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    //    //姓
    //    NSString * nameString = (__bridge NSString *)firstName;
    //    //名
    //    NSString * lastString = (__bridge NSString *)lastName;
    //第二种方法：全名
    CFStringRef anFullName = ABRecordCopyCompositeName(person);
    
    _addressBookCallBack([NSString stringWithFormat:@"%@, %@",telValue,anFullName]);
    
    [self dismissViewControllerAnimated:YES completion:^{
      
    }];
}

-(NSString*)DataTOjsonString:(NSObject * )object
{
    NSDictionary * dict = @{@"code":@"0",@"msg":@"sucess",@"data":object};
    return [self DictTOjsonString:dict];
    
}
//json 字符串
-(NSString*)DictTOjsonString:(NSObject * )dict
{

    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    

    
//    NSData * getJsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

//    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];

//    NSString * string = [getDict objectForKey:@"data"];
//    
//    //Base64字符串转UIImage图片：
//    NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *decodedImage = [UIImage imageWithData:decodedImgData];
//    
//
//    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
//    imgV.contentMode = UIViewContentModeScaleAspectFit;
//    [imgV setImage:decodedImage];
//    [self.view addSubview:imgV];

    
    return jsonString;
}

-(void)dealloc
{
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
