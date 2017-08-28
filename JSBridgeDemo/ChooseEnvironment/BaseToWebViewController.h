//
//  BaseToWebViewController.h
//  taoqianbao
//
//  Created by tim on 16/9/25.
//  Copyright © 2016年 tim. All rights reserved.
//

#import "TOWebViewController.h"


@interface BaseToWebViewController : TOWebViewController

@property (strong,nonatomic) UIButton *rightBtn;
///分享的

-(void)jumpToWebFrom:(UIViewController *)vc vcIsNav:(BOOL)vcIsNav withAddress:(NSString *)address;
-(void)jumpToWebFrom:(UIViewController *)vc vcIsNav:(BOOL)vcIsNav ;

-(void)webviewDidClose;


-(void)setBackAsWhite:(BOOL)white;
-(void)setBackBtnImage:(UIImage*)image;
-(void)backItemAct:(id)sender;
-(void)enableCloseBtn:(BOOL)enable;

@end
