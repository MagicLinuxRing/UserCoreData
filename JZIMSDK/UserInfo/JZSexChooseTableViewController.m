//
//  JZSexChooseTableViewController.m
//  JZIMSDK
//
//  Created by king jack on 15/10/8.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZSexChooseTableViewController.h"

@interface JZSexChooseTableViewController ()

@end

@implementation JZSexChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"性别";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sexCellIdentifier = @"sexCell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sexCellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sexCellIdentifier];
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"男";
        if ([self.sex isEqualToString:@"male"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
            cell.accessoryType =  UITableViewCellAccessoryNone;
    }
    else
    {
        cell.textLabel.text = @"女";
        if ([self.sex isEqualToString:@"male"])
        {
            cell.accessoryType =  UITableViewCellAccessoryNone;
        }
        else
            cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([self.delegate respondsToSelector:@selector(modifySexWithIndex:)])
    {
        [self.delegate modifySexWithIndex:indexPath.row];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
