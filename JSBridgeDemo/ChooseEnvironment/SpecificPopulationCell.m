//
//  SpecificPopulationCell.m
//  GmHouseClerk
//
//  Created by liuYaLin on 16/7/21.
//  Copyright © 2016年 GMJR. All rights reserved.
//

#import "SpecificPopulationCell.h"
#import <Masonry/Masonry.h>
#import "defines.h"

@implementation SpecificPopulationCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creaeUI];
    }
    return self;
}


-(void)creaeUI{

    [self.contentView addSubview:self.mainTitleLabel];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.spliteView];
    
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(KScreenWidth/2);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
//        make.size.mas_equalTo(CGSizeMake(10, 7));
        
    }];
    
    [self.spliteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainTitleLabel.mas_bottom).offset(-1);
        make.left.equalTo(self.contentView.mas_left).offset(15);

        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.offset(0.5);
    }];
    


}
-(UILabel *)mainTitleLabel{
    if (!_mainTitleLabel) {
        _mainTitleLabel=[[UILabel alloc]init ];
        _mainTitleLabel.font=Font(15);
        _mainTitleLabel.textColor= KRedColor;
    }
    return _mainTitleLabel;
}


-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView=[[UIImageView alloc]init ];
    }

    return _rightImageView;
}
-(UIView *)spliteView{
    if (!_spliteView) {
        _spliteView=[[UIView alloc]init ];
        _spliteView.backgroundColor=[UIColor colorWithRed:0.78f green:0.78f blue:0.80f alpha:1.00f];
    }

    return _spliteView;
}



@end
