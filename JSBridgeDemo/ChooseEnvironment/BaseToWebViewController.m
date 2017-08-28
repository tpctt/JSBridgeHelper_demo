//
//  BaseToWebViewController.m
//  taoqianbao
//
//  Created by tim on 16/9/25.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "BaseToWebViewController.h"


#import "TQBJSBridgeHelper.h"


#import "NJKWebViewProgress.h"


// Controllers

// Model

// Views


//#define <#macro#> <#value#>


@interface BaseToWebViewController ()

//@property (nonatomic, strong) <#type#> *<#name#>
{
    ///维护自定义 header 的 historylist
    NSMutableArray *_historyList; //堆栈
    NSMutableURLRequest *_preRequest;
    NSInteger _historyIndex ; ///指针
    
    UIButton *backBtn;
    
}



@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) TQBJSBridgeHelper *jsBridgeHelper;
@property (nonatomic,strong) NJKWebViewProgress *progressManager222;

@end

@implementation BaseToWebViewController


#pragma mark - View Controller LifeCyle
-(void)webviewDidClose
{}
static bool modelVC = NO;
-(void)jumpToWebFrom:(UIViewController *)vc vcIsNav:(BOOL)vcIsNav
{
    [self jumpToWebFrom:vc vcIsNav:vcIsNav withAddress:nil];
}

-(void)jumpToWebFrom:(UIViewController *)vc vcIsNav:(BOOL)vcIsNav  withAddress:(NSString *)address
{
    
}
-(void)closeWebView
{
    if( modelVC ){
        [self.navigationController dismissViewControllerAnimated:1 completion:^{
            
        }];
        
    }else{
        [self.navigationController popViewControllerAnimated:1];
        
    }
    [self webviewDidClose];
}

///分享到3方数据
-(void)shareInfo:(NSString *)url
{

}

///打开一个新网页
-(void)openWebUrl:(NSString *)url
{
//    NSURL *url2 = [NSURL URLWithString:url];
//    NSDictionary *dict = [url2 params];
//    if (dict.allKeys.count == 0) {
//        url2 = [NSURL URLWithString:[url2.absoluteString urldecode  ]];
//        dict =  [url2 params];
//    }
//    NSString *herf = [dict objectForKey:@"url"];
//    
//    BaseToWebViewController *webVC = [[BaseToWebViewController alloc] initWithURLString:herf];
//    
//    [self.navigationController pushViewController:webVC animated:YES];
    
    
}
///去登录
-(void)jumpToLogin:(NSString *)url
{
    if( modelVC ){
//        [self.navigationController dismissViewControllerAnimated:1 completion:^{
//            
//        }];
        
        
    }else{
//        [self.navigationController popViewControllerAnimated:1];
        
        
    }
//    [self webviewDidClose];
    
    
    
}
//打开产品详情页
-(void)openProductView:(NSString *)url
{

    
}
///打开经理详情页
-(void)openDirectorView:(NSString *)url
{
    
    
    
}
///打开信用卡详情页
-(void)openCreditCardView:(NSString *)url
{
    
    
    
}
-(void)addNotifaction_login
{
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}   
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showUrlWhileLoading = NO;
        
    }
    return self;
}

-(instancetype)initWithURLString:(NSString *)urlString
{
    self = [super initWithURLString:urlString];
    if (self) {
        self.showUrlWhileLoading = NO;
        
    }
    return self;
}

-(instancetype)initWithURL:(NSURL *)url
{
    self = [super initWithURL:url];
    if (self) {
        self.showUrlWhileLoading = NO;
        
    }
    return self;
}



-(void)initJsBridgeHelper
{
    self.jsBridgeHelper = [[TQBJSBridgeHelper alloc] init];
    self.jsBridgeHelper.webView = self.webView;
    self.jsBridgeHelper.webViewController = self;
    [self.jsBridgeHelper injectJSBridge];
    
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // 注册拦截请求的NSURLProtocol
//    [NSURLProtocol registerClass:[WebViewURLProtocol class]];
    
    
    [self initialNavigationBar];
    
    [self setCustomBackItem];
    
    [self disableWebCache:YES];
    
    [self addMJHeaderOnWebView];
    
    [self setBackAsWhite:YES];
    
    [self initJsBridgeHelper];
    
    ///避免 js/progress 冲突
    self.progressManager222 = [self valueForKeyPath:@"_progressManager"];
    self.progressManager222.webViewProxyDelegate = nil;
    
    NSLog(@"%@,,",[self valueForKeyPath:@"_progressManager"]);
    
    
    _historyList = [NSMutableArray array  ];
    
    [self.closeBtn setTitle:nil forState:UIControlStateSelected];
    [self.closeBtn setImage:[UIImage imageNamed:@"tag_btn_close_del.png"] forState:UIControlStateSelected];
    
    
    self.rightBtn = [[UIButton alloc] init];
//    self.rightBtn.titleLabel.font = 

    //分享功能

    

    [self setBackAsWhite:YES];
    
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    [bar setBackgroundColor:[self fromHexValue:0x1a6cf0]];
    
    [bar setTintColor:[self fromHexValue:0x1a6cf0]];
//    bar.barTintColor   [self fromHexValue:0x1a6cf0]];

    [bar setBarTintColor:[self fromHexValue:0x1a6cf0]];
    
//    [bar :[self navigationBarInColor]];
//    [bar gjw_setTitleAttributes:[self navigationTitleAttributes]];
//    [bar gjw_setShadowImage:[self navigationBarShadowImage]];
    
}

- (UIColor *)fromHexValue:(NSUInteger)hex
{
    NSUInteger a = ((hex >> 24) & 0x000000FF);
    float fa = ((0 == a) ? 1.0f : (a * 1.0f) / 255.0f);
    
    return [self fromHexValue:hex alpha:fa];
}

- (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha
{
    if ( hex == 0xECE8E3 ) {
        
    }
    NSUInteger r = ((hex >> 16) & 0x000000FF);
    NSUInteger g = ((hex >> 8) & 0x000000FF);
    NSUInteger b = ((hex >> 0) & 0x000000FF);
    
    float fr = (r * 1.0f) / 255.0f;
    float fg = (g * 1.0f) / 255.0f;
    float fb = (b * 1.0f) / 255.0f;
    
    return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}
//下拉刷新
-(void)addMJHeaderOnWebView
{
//    @weakify(self);
    
    //下拉刷新
//    self.webView.scrollView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
//        
//        @strongify(self);
//        
//        [self.webView reload];
//        //        [self.webView.scrollView.mj_header endRefreshing];
//        [self.webView.scrollView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1 ];
//        
//    }];
    self.navigationButtonsHidden = YES;
    
    
}
//禁用缓存?
-(void)disableWebCache:(BOOL)disable
{
    if (disable) {
        //禁用缓存
        self.urlRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        
    }
}

///使用自定义的返回按钮
-(void)setCustomBackItem
{
    
    //    self.navigationButtonsHidden = YES;
    //    self.showDoneButton
//    self.applicationLeftBarButtonItems = @[[self backBarButtonItem],[self closeBarButtonItem] ];
    
    //    self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
//    @weakify(self);
//    self.navigationItem.leftItemsSupplementBackButton = NO;
//    [RACObserve(self.navigationItem, leftItemsSupplementBackButton)subscribeNext:^(id x) {
//        @strongify(self);
//        if(self.navigationItem.leftItemsSupplementBackButton) self.navigationItem.leftItemsSupplementBackButton=  NO;
////        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
//        
//        if(self.rightBtn){
////            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
//            
//            
//        }
//        
//        
//    }];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    self.navigationItem.leftItemsSupplementBackButton = NO;

}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    self.navigationItem.leftItemsSupplementBackButton = NO;
    [self.jsBridgeHelper viewWillAppear];
    
}

-(UIBarButtonItem *)backBarButtonItem{
    UIBarButtonItem *item ;
    if (item) {
        return item;
    }
    
//    if (!item) {
//        //        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:NULL];
//        
//        UIImage *image  = [[UIImage imageNamed:@"nav_return.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        
//        backBtn = [[UIButton alloc] initNavigationButton:image];
//        //item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backItemAct:)];
//        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        backBtn.width = 24;
//
//        item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//        
//        [backBtn addTarget:self action:@selector(backItemAct:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//    }
    return item;
}

//-(UIBarButtonItem *)closeBarButtonItem{
//    UIBarButtonItem *item ;
//    if (item) {
//        return item;
//    }
//    
////    if (!item) {
//////        item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target: self action:@selector(clsoeItemAct:)];
////        
//////        UIImage *image  = [[UIImage imageNamed:@"nav_return.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////        
////        _closeBtn = [[UIButton alloc] initNavigationButtonWithTitle:@"关闭" color: TextColor];
////        _closeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
////        //item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backItemAct:)];
////        
////
////        _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
////        
////        item = [[UIBarButtonItem alloc] initWithCustomView:_closeBtn];
////        
////        [_closeBtn addTarget:self action:@selector(clsoeItemAct:) forControlEvents:UIControlEventTouchUpInside];
////        
////    }
////    return item;
//}

-(void)clsoeItemAct:(id)sender
{
    [self.navigationController popViewControllerAnimated:1];
    [self webviewDidClose];

}

-(void)backItemAct:(id)sender
{
//    _historyIndex --;
//    
//    NSMutableURLRequest *request = [_historyList safeObjectAtIndex:_historyIndex - 1 ];
//    if (request) {
//        [self.webView loadRequest:request];
//    }else
//    {
//        
//        [[TQBStatistialFunction sharedSingleton] recordEvent:dianji_fanhui segmentationKey: dianji_fanhui segmentation:@{@"action":@"goback",
//                                                                                                                         @"viewname":@"网页"}];
//        [self.navigationController popViewControllerAnimated:1];
//        [self webviewDidClose];
//
//    }

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [NSURLProtocol unregisterClass:[WebViewURLProtocol class]];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

//    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"%@ %@", NSStringFromSelector(_cmd) , self );
    
}

#pragma mark - Override

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
//    self.navigationItem.title = <#title#>;
}


#pragma mark - Target Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark -
#pragma mark UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.progressManager222 respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.progressManager222 webViewDidFinishLoad:webView ];
    }
    
    [super webViewDidFinishLoad:webView];
    
    if (NO == [_historyList containsObject:_preRequest]) {
        
        
//        _historyList = [_historyList safeSubarrayWithRange:NSMakeRange(0, _historyIndex)].mutableCopy;
        if (_historyIndex>=0) {
            [_historyList insertObject:_preRequest atIndex:_historyIndex];
            _historyIndex ++;

        }else{
            
            [_historyList insertObject:_preRequest atIndex:0];
            _historyIndex = 0 ;

        }
        
    }
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([self.progressManager222 respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        [self.progressManager222 webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    
    BOOL flag = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    if (flag == NO) {
        return NO;
    }
    
    
//    return YES;
    ///通过 url 关闭 webview
    /// 当 webview 调用 tqb_close_webview:// XX 的时候 app 关闭当前网页
    //4.1
    if ([request.URL.absoluteString hasPrefix:@"tqb_close_webview://"]) {
        [self closeWebView];
        return NO;
    }
    //4.2
    if ([request.URL.absoluteString hasPrefix:@"tqb://close_webview"]) {
        [self closeWebView];
        return NO;
    }
    if ([request.URL.absoluteString hasPrefix:@"tqb://jump_vc"]) {
        [self jumpToLogin:request.URL.absoluteString];
        return NO;
    }
    ///4.3
    if ([request.URL.absoluteString hasPrefix:@"tqb://shareInfo"]) {
        [self shareInfo:request.URL.absoluteString];
        return NO;
    }
    ///客狐2.0
    if ([request.URL.absoluteString hasPrefix:@"tqb://openWebUrl"]) {
        [self openWebUrl:request.URL.absoluteString];
        return NO;
    }
    ///tqb5.1.1
    if ([request.URL.absoluteString hasPrefix:@"tqb://openProductView"]) {
        [self openProductView:request.URL.absoluteString];
        return NO;
    }
    ///tqb5.1.1
    if ([request.URL.absoluteString hasPrefix:@"tqb://openDirectorView"]) {
        [self openDirectorView:request.URL.absoluteString];
        return NO;
    }
    ///tqb5.1.1
    if ([request.URL.absoluteString hasPrefix:@"tqb://openCreditCardView"]) {
        [self openCreditCardView:request.URL.absoluteString];
        return NO;
    }
    
    
    
    if ([request.URL.absoluteString hasPrefix:@"tqb://customerService"]) {
        
//        [[Config sharedInstance] contactUs];

        return NO;
    }
    
    
    
    NSLog(@"%@",request.URL.host );
//    if(request.URL.host==nil){
//        if([request.URL.absoluteString isEqualToString:@"about:blank"]){
//            ///about:blank
//            return NO;
//        }
//    }
//    
    
    
    
    ///只添加 header 到自己的服务器的 domain
    if([request.URL.host hasSuffix:@"taoqian123.com"] ||
       [request.URL.host hasSuffix:@"taoqian123.dev"] ||
       [request.URL.host hasSuffix:@"kehufox.com"] ||
       [request.URL.host hasSuffix:@"kehufox.dev"] ||
       [request.URL.host hasSuffix:@"taoqian123.taoqian123.com.cn"] ||
       [request.URL.host hasSuffix:@"kehufox.taoqian123.com.cn"]
       
       
       )
    {
        
        NSString *front1 =  [[request allHTTPHeaderFields] objectForKey:@"front"];
        //    NSString *front2 =  [[self.urlRequest allHTTPHeaderFields] objectForKey:@"front"];
        
        
        BOOL headerIsPresent = (front1.length!= 0) ;
        self.jsBridgeHelper.currentUrl = [request.URL absoluteString];

        if(headerIsPresent) return YES;
        
        NSMutableURLRequest *mRequest = [request mutableCopy];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                NSDictionary *baseInfo  = [BaseViewModel addBaseInfo:nil forWeb:YES];
//                for (NSString *key in [baseInfo allKeys] ) {
//                    [mRequest  addValue:[baseInfo objectForKey:key] forHTTPHeaderField:key];
//                    
//                }
//                // set the new headers
//                
//                if(request){
//                    _preRequest = mRequest;
//                }
//                
//                
//                // reload the request
//                [webView loadRequest:mRequest ];
//                
//            });
//        });
        return NO;

    }else{
        
        if(request){
            _preRequest = request.mutableCopy;
        }
        self.jsBridgeHelper.currentUrl = [request.URL absoluteString];
        return YES;
        
    }
    
   
    
//    return [super webView:webView shouldStartLoadWithRequest:mRequest navigationType:navigationType];
    
    
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.progressManager222 respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.progressManager222 webViewDidStartLoad:webView];
    }
    
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.progressManager222 respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.progressManager222 webView:webView didFailLoadWithError:error];
    }
}




#pragma mark - Privater Methods


#pragma mark - Setter Getter Methods

-(void)setBackAsWhite:(BOOL)white
{
    [backBtn setImage: [UIImage imageNamed:white?@"nav_return_white":@"nav_return.png"]  forState:0];
//    [ self.closeBtn setTitleColor:white?[UIColor whiteColor]:TextColor forState:0];
    
}
-(void)setBackBtnImage:(UIImage*)image
{
    [backBtn setImage: image forState:0];
    
}

//-(void)backItemAct:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:1];
//    
//}


-(void)enableCloseBtn:(BOOL)enable
{
    self.closeBtn.hidden = !enable;
}

#if TimCustomNAV
-(UIColor *)navigationBarOutColor
{
    return [self navigationBarInColor];
}
-(UIColor *)navigationBarInColor
{
    return  NavBarMC;

}
-(UIImage *)navigationBarShadowImage
{
    UIColor *color = [self navigationBarInColor];
    
    if( CGColorEqualToColor(color.CGColor, NavBarMC.CGColor) ){
        return nil;
        
    }else{
        return [UIImage new];
        
    }
    
}
- (BOOL)enablePanBack
{
    return YES;
}
- (NSDictionary *)navigationTitleAttributes
{
    return   @{
               NSForegroundColorAttributeName: HEX_RGB(0xffffff) ,
               NSFontAttributeName:[UIFont systemFontOfSize:18],
               
               };
    
}

#endif
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
