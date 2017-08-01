//
//  LoginOutViewController.h
//  JSBridgeDemo
//
//  Created by tim on 2017/8/1.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginOutDelegate<NSObject>

-(void)didLogin:(id)data;
-(void)didLogout:(id)data;
-(void)didRecevieMsg:(NSString *)msg;

@end

@interface LoginOutViewController : UIViewController


@property (weak,nonatomic) id<LoginOutDelegate> delegate;

@end
