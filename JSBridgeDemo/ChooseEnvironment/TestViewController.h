//
//  TestViewController.h
//  GmHouseClerk
//
//  Created by liuYaLin on 16/7/31.
//  Copyright © 2016年 GMJR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TestVCChooseComputingBlock)(NSString *computing, NSString *valueString);

@interface TestViewController : UIViewController
@property (nonatomic, copy) TestVCChooseComputingBlock block;

- (void)chooseComputingBlock:(TestVCChooseComputingBlock)blcok;
@end
