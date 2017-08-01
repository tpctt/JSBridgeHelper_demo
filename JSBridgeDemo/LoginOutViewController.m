//
//  LoginOutViewController.m
//  JSBridgeDemo
//
//  Created by tim on 2017/8/1.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//

#import "LoginOutViewController.h"

@interface LoginOutViewController ()

@end

@implementation LoginOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
static bool isLogded ;

- (IBAction)login:(id)sender {
    if (isLogded == NO) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLogin:)] ) {
            isLogded = YES;
            [self.delegate didLogin:@"登录成功"];
            
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didRecevieMsg:)] ) {
            [self.delegate didRecevieMsg:@"已经登录"];
            
        }
    }
    
    [self dismissViewControllerAnimated:1 completion:^{
        
    }];
    
}
- (IBAction)logout:(id)sender {
    if (isLogded == YES) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLogin:)] ) {
            isLogded = NO;
            [self.delegate  didLogout:@"注销成功"];
            
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didRecevieMsg:)] ) {
            [self.delegate didRecevieMsg:@"已经注销"];
            
        }
    }
    [self dismissViewControllerAnimated:1 completion:^{
        
    }];
    
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
