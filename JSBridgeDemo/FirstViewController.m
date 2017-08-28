//
//  FirstViewController.m
//  JSBridgeDemo
//
//  Created by gomeguomingyue on 2017/5/10.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//

#import "FirstViewController.h"
#import "TestViewController.h"
//#import "constant.h"
#import "defines.h"
#import "BaseToWebViewController.h"

#import "TQBJSBridgeHelper.h"

@interface FirstViewController ()

@property (nonatomic, assign) BOOL show;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self buttonAction];
    
    UIButton *button = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(100, 100, 100, 30);
        [button setTitle:@"选择环境" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:button];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)buttonAction
{
    self.show = YES;
#ifdef __Choose_Evn__
    
    if (self.show) {
        TestViewController *testVC = [[TestViewController alloc] init];
        
        self.show = NO;
        

        [self presentViewController:testVC animated:YES completion:nil];
        
        [testVC chooseComputingBlock:^(NSString *computing, NSString *valueString) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dismissViewControllerAnimated:YES completion:nil];

                BaseToWebViewController * ViewController;
                if ([WKWebView class]) {
                    ViewController = [[BaseToWebViewController alloc] initWithURLString:valueString];
                    [self.navigationController pushViewController:ViewController animated:YES];
                }
                
            });
        }];
    }
    
    
    
#endif
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
