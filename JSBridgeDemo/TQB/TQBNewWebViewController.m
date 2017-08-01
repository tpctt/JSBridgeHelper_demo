//
//  TQBNewWebViewController.m
//  JSBridgeDemo
//
//  Created by Zhang Wuyang on 2017/7/21.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//

#import "TQBNewWebViewController.h"
#import "MYFDefines.h"


@interface TQBNewWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* webView;

@end

@implementation TQBNewWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    //self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    //self.webView.navigationDelegate = self;
    self.webView.delegate = self;
    
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.webView];
    
    
    NSString* htmlPath = self.url;
    NSURL *baseURL = [NSURL URLWithString:htmlPath];
    [_webView loadRequest:[NSMutableURLRequest requestWithURL:baseURL]];

    //    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
