//
//  ViewController.m
//  JSBridgeDemo
//
//  Created by gomeguomingyue on 2017/4/27.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//  

#import "WKViewController.h"
#import "WKWebViewJavascriptBridge.h"


#import "GMSystemAuthorizationTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "LocationTools.h"
#import "TestViewController.h"
#import "constant.h"
#import "defines.h"
#import "UIImage+Rotate.h"

@interface WKViewController ()<WKUIDelegate,UIWebViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property WKWebViewJavascriptBridge * bridge;
@property (nonatomic, strong) WKWebView* webView;

@property (nonatomic, copy) WVJBResponseCallback responseCallback;//照片
@property (nonatomic, copy) WVJBResponseCallback locationResponseCallback;//定位
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation WKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"JavaScriptBridge";
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    
    //初始化progressView
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, 2.0f)];
    self.progressView.backgroundColor = [UIColor blueColor];
    self.progressView.transform = CGAffineTransformMakeScale(1.0, 1.5f);
    [self.view addSubview:self.progressView];
    
    //清理缓存
    [self deleteWebCache];
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
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, DEVICE_HEIGHT-20)];
    //self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    //self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.webView];
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    //注册方法
    __weak typeof(self) weakSelf = self;
    
    [_bridge registerHandler:@"gome_getphoto" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"call back gome_getphoto:%@",data);
        weakSelf.responseCallback = responseCallback;
        [weakSelf photographAction];
    }];
    [_bridge registerHandler:@"gome_getgps" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"call back gome_getgps:%@",data);
        weakSelf.locationResponseCallback = responseCallback;
        [weakSelf locationAction];
    }];
    
    //加载页面
    [self loadExamplePage:self.webView];
}

- (void)loadExamplePage:(WKWebView*)webView {
    
    NSLog(@"baseUrl = %@", baseUrl);
    NSString* htmlPath = baseUrl;
    NSURL *baseURL = [NSURL URLWithString:htmlPath];
    [webView loadRequest:[NSMutableURLRequest requestWithURL:baseURL]];
    
}

#pragma mark - events handle
-(void)photographAction
{
    NSLog(@"photographAction");
    //打开相机
    [GMSystemAuthorizationTool checkCameraAuthorization:^(bool isAuthorized, AVAuthorizationStatus authorStatus) {
        if (isAuthorized) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
                    pickerViewController.delegate = self;
                    pickerViewController.allowsEditing = NO;
                    pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self presentViewController:pickerViewController animated:YES completion:nil];
                });
            }
        } else {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"美借未获取相机权限" message:@"请在系统设置中允许“美借”访问相机\n 设置-> 隐私-> 相机 -> 美借" preferredStyle:UIAlertControllerStyleAlert];
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
    
    //打开相册
    /*
    [GMSystemAuthorizationTool checkPhotographAlbumAuthorization:^(bool isAuthorized) {
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
                
            }
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"美易分获取位置权限" message:@"请在系统设置中允许“美易分”访问位置\n 设置-> 隐私-> 相册 -> 美易分" preferredStyle:UIAlertControllerStyleAlert];
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
     */
}

-(void)locationAction
{
    NSLog(@"locationAction");
    
    [GMSystemAuthorizationTool checkLocationAuthorization:^(bool isAuthorized, CLAuthorizationStatus status) {
        if (isAuthorized) {
            [[LocationTools sharedInstance] getCurrentLocation:^(CLLocation *location, CLPlacemark *pl, NSString *error, BOOL loading) {
                if (pl.locality.length > 0) {
                    self.locationResponseCallback([NSString stringWithFormat:@"%@/%@,%lf/%lf",pl.administrativeArea,pl.locality,location.coordinate.latitude, location.coordinate.longitude]);
                }
            }];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"美借获取位置权限" message:@"请在系统设置中允许“美借”访问位置\n 设置-> 隐私-> 位置 -> 美借" preferredStyle:UIAlertControllerStyleAlert];
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
    //image = [image imageRotatedByDegrees:0.0f];
    NSLog(@"image.size1 = %@",[NSValue valueWithCGSize:image.size]);
    NSData *data = UIImageJPEGRepresentation(image, 0.1f);
    NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"base64String = %@",base64String);
    self.responseCallback(base64String);
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
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    //self.title = webView.title;
    NSLog(@"webViewDidStartLoad");
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"webViewDidFinishLoad");
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"webViewDidFail");
    self.progressView.hidden = YES;
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"runJavaScriptAlertPanelWithMessage");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    completionHandler();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

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

-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
