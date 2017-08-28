//
//  UIButton+EasyExtend.m
//  leway
//
//  Created by 朱潮 on 14-6-7.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "UIButton+EasyExtend.h"
#undef	NAV_BUTTON_MIN_WIDTH
#define	NAV_BUTTON_MIN_WIDTH	(40.0f)

#undef	NAV_BUTTON_MIN_HEIGHT
#define	NAV_BUTTON_MIN_HEIGHT	(40.0f)

#undef	NAV_BAR_HEIGHT
#define	NAV_BAR_HEIGHT	(44.0f)

@implementation UIButton (EasyExtend)


-(UIButton *)initNavigationButtonWithTitle:(NSString *)str color:(UIColor *)color{
    CGRect buttonFrame = CGRectZero;

    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(999999.0f, NAV_BAR_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    

        buttonFrame = CGRectMake(0, 0, titleSize.width, NAV_BAR_HEIGHT);

    self = [self initWithFrame:buttonFrame];
	self.contentMode = UIViewContentModeScaleAspectFit;
	self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitle:str forState:UIControlStateNormal];
    return self;
}
@end
