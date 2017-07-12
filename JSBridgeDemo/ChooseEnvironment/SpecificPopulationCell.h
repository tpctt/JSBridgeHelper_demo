//
//  SpecificPopulationCell.h
//  GmHouseClerk
//
//  Created by liuYaLin on 16/7/21.
//  Copyright © 2016年 GMJR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CustomSelectBlock)(BOOL selected, NSInteger row);

@interface SpecificPopulationCell : UITableViewCell
/**
 *标题
 */
@property(nonatomic, strong)UILabel *mainTitleLabel;
/**
 * 选中图片
 */
@property(nonatomic ,strong)UIImageView *rightImageView;
/**
 *分割线
 */
@property(nonatomic, strong)UIView *spliteView;



@end
