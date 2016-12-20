//
//  BaseTabBarController.m
//  PlayEnglish_iOS
//
//  Created by 吴戈 Wougle on 16/9/25.
//  Copyright © 2016年 DMT. All rights reserved.
//

#import "BaseTabBarController.h"
#import "PEHomeTableViewController.h"
#import "PECommunityTableViewController.h"
#import "PEMineTableViewController.h"
@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 默认
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    attrs[NSForegroundColorAttributeName] = Rgb2UIColor(136, 138, 144, 1.);
    
    // 选中
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    attrSelected[NSForegroundColorAttributeName] = Rgb2UIColor(228, 75, 59, 1.);
    
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"首页-未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"首页-首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    item1.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    item1.title = @"首页";
    [item1 setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"社区-未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"社区-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    item2.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    item2.title = @"社区";
    [item2 setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item2 setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
    
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"我的"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"我的-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    item3.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    item3.title = @"我的";
    [item3 setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
    

    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:[PEHomeTableViewController new]];
    nav1.tabBarItem = item1;
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[PECommunityTableViewController new]];
    nav2.tabBarItem = item2;
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:[PEMineTableViewController new]];
    nav3.tabBarItem = item3;
    
    
    self.viewControllers = @[nav1, nav2, nav3];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
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
