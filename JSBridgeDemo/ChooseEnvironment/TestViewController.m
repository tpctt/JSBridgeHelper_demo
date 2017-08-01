//
//  TestViewController.m
//  IOUsDemo
//
//  Created by liuYaLin on 16/7/31.
//  Copyright © 2016年 GMJR. All rights reserved.
//

#import "TestViewController.h"
#import "SpecificPopulationCell.h"
#import <Masonry/Masonry.h>
#import "defines.h"
#import "ViewController.h"

@interface TestViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, weak) UILabel *currentUrlDesLabel;

@property (nonatomic, strong) NSDictionary *computingDict;

@property(nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign) NSInteger currentSelectIndex;

@property (nonatomic, strong) UITextField *currentUrlTextField;

@end



@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"环境选择";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = KBackgroundColor;//15670502091//qwer1234

    
    NSString *computingPath = [[NSBundle mainBundle] pathForResource:@"ChooseComputing" ofType:@".plist"];
    NSDictionary *computingDict = [NSDictionary dictionaryWithContentsOfFile:computingPath];
    self.computingDict = computingDict;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, KScreenWidth, 20)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = @"2017-7-18 11:46";
    timeLabel.textColor = [UIColor redColor];
    [self.view addSubview:timeLabel];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, KScreenWidth, 40)];
    tipLabel.text = @"当前选择环境";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    
    UILabel *currentUrlDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLabel.frame), KScreenWidth, 40)];
    self.currentUrlDesLabel = currentUrlDesLabel;
    currentUrlDesLabel.text = @"DEV";
    currentUrlDesLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:currentUrlDesLabel];
    
    UITextField *currentUrlTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(currentUrlDesLabel.frame), KScreenWidth, 40)];
    currentUrlTextField.text = [self.computingDict objectForKey:@"DEV"];
    self.currentUrlTextField = currentUrlTextField;
    currentUrlTextField.textAlignment = NSTextAlignmentCenter;
    currentUrlTextField.returnKeyType = UIReturnKeyGo;
    currentUrlTextField.delegate = self;
    [self.view addSubview:currentUrlTextField];
    
    [self.view addSubview:self.tableView];
    
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

}


/*
 *
 */
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.currentUrlTextField.frame), KScreenWidth, KScreenHeight - CGRectGetMaxY(self.currentUrlTextField.frame)) style:UITableViewStyleGrouped ];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //设置tableview多选
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        
        
        _tableView.backgroundColor=[UIColor colorWithRed:0.94f green:0.95f blue:0.95f alpha:1.00f];
    }
    return _tableView;
}

#pragma mark--UITableViewDelegate,UITableViewDataSource
/*
 *
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.computingDict allKeys] count];
}


/*
 *
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecificPopulationCell *cell=[[SpecificPopulationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil ];
    cell.mainTitleLabel.text = [self.computingDict allKeys][indexPath.row];
    cell.selectionStyle = 0;
    if (self.currentSelectIndex  == indexPath.row)
    {
        cell.rightImageView.image=[UIImage imageNamed:@"cashLoan_quota_image"];
    }
    else
    {
        cell.rightImageView.image=nil;
    }
    return cell;
}




/*
 *
 */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, KScreenWidth, (KScreenHeight-([self.computingDict allKeys].count * 64 * KScaleY +64))) ];
    
    footView.backgroundColor=KBackgroundColor;
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:1.00f green:0.45f blue:0.26f alpha:1.00f];
    [button setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView.mas_left).offset(15);
        make.right.equalTo(footView.mas_right).offset(-15);
        make.top.equalTo(footView.mas_top).offset(40);
        make.height.offset(60);
    }];
    
    return footView;
}


/*
 *
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  (KScreenHeight-(self.computingDict.allKeys.count * 64 * KScaleY +64));
}


/*
 *
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


/*
 *
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64 * KScaleY;
}

/**
 *  cell的选中
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.currentSelectIndex = indexPath.row;
    self.currentUrlDesLabel.text = [self.computingDict allKeys][indexPath.row];
    self.currentUrlTextField.text = [self.computingDict objectForKey:self.currentUrlDesLabel.text];
    if (indexPath.row == 0) {
        [self.currentUrlTextField becomeFirstResponder];
    }
    [self.tableView reloadData];
}

- (void)commitButtonClicked
{
    
    self.block(self.currentUrlDesLabel.text, self.currentUrlTextField.text);
}

- (void)chooseComputingBlock:(TestVCChooseComputingBlock)blcok
{
    self.block = blcok;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.currentUrlTextField resignFirstResponder];
    [self commitButtonClicked];
    return YES;
}

@end
