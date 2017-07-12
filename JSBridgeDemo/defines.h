//
//  defines.h
//  JSBridgeDemo
//
//  Created by gomeguomingyue on 2017/5/10.
//  Copyright © 2017年 gomeguomingyue. All rights reserved.
//

#ifndef defines_h
#define defines_h

#define __Choose_Evn__

#define ShortSystemVersion  [[UIDevice currentDevice].systemVersion floatValue]
// 判别系统版本
#define IS_IOS_6 (ShortSystemVersion < 7)
#define IS_IOS_7 (ShortSystemVersion >= 7 && ShortSystemVersion < 8)
#define IS_IOS_8 (ShortSystemVersion >= 8)
#define IOS9_OR_LATER (ShortSystemVersion >= 9)
// 判别设备类型
#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsPortrait(self.interfaceOrientation)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

// 自定义RGB色值
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
// 自定义有透明度的RGB色值
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define KBackgroundColor   RGBACOLOR(239, 239, 244, 0.8)
// 屏幕尺寸
#define KScreenBounds [UIScreen mainScreen].bounds
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
// 适配X轴、Y轴方向
#define KScaleX (KScreenWidth/375.0)
#define KScaleY (KScreenHeight/667.0)

// 字体
#define GMFONTSCALE(originFont) DEVICE_HEIGHT > 568 ? originFont : (originFont - 2)
#define Font(fontSize)  (IOS9_OR_LATER?[UIFont fontWithName:@"PingFangSC-Regular" size:GMFONTSCALE(fontSize)]:[UIFont systemFontOfSize:GMFONTSCALE(fontSize)])

// 屏幕尺寸
#define DEVICE_BOUNDS [UIScreen mainScreen].bounds
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KInset 15
#define Wfont14 [UIFont systemFontOfSize:GMFONTSCALE(12) weight:3]

// 获取系统色值
#define KBackgroundColor   RGBACOLOR(239, 239, 244, 0.8)
#define KLightBlueColor    RGBCOLOR(84, 141, 235)
#define KBlackColor        [UIColor blackColor]
#define KDarkGrayColor     [UIColor darkGrayColor]
#define KLightGrayColor    [UIColor lightGrayColor]
#define KWhiteColor        [UIColor whiteColor]
#define KGrayColor         [UIColor grayColor]
#define KRedColor          [UIColor redColor]
#define KGreenColor        [UIColor greenColor]
#define KBlueColor         [UIColor blueColor]
#define KCyanColor         [UIColor cyanColor]
#define KYellowColor       [UIColor yellowColor]
#define KMegentaColor      [UIColor magentaColor]
#define KOrangeColor       [UIColor orangeColor]
#define KPurpleColor       [UIColor purpleColor]
#define KBrownColor        [UIColor brownColor]
#define KClearColor        [UIColor clearColor]

#endif /* defines_h */
