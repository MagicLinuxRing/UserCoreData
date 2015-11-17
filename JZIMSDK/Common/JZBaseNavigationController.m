//
//  JZBaseNavigationController.m
//  JZIMSDK
//
//  Created by king jack on 15/9/25.
//  Copyright © 2015年 kingJ. All rights reserved.
//

#import "JZBaseNavigationController.h"
#import "UIColor+Custom.h"

@interface JZBaseNavigationController ()

@end

@implementation JZBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize {
    
    // 1.appearance方法返回一个导航栏的外观对象
    
    //修改了这个外观对象，相当于修改了整个项目中的外观
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    [navigationBar setBarTintColor:[UIColor colorWithHexString:@"0xFBA73C"]];
    
    [navigationBar setTintColor:[UIColor whiteColor]];// iOS7的情况下,设置NavigationBarItem文字的颜色
    
    // 3.设置导航栏文字的主题
    
    NSShadow *shadow = [[NSShadow alloc]init];
    
    [shadow setShadowOffset:CGSizeZero];
    
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                            
                                            NSShadowAttributeName : shadow}];
    
    [navigationBar setBackgroundColor:[UIColor colorWithHexString:@"0xFBA73C"]];
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    
    // 4.修改所有UIBarButtonItem的外观
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        
        [barButtonItem setTintColor:[UIColor whiteColor]];
        
    }else
    {
        
        // 修改item的背景图片
        
        //[barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        //[barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        // 修改item上面的文字样式
        
        NSDictionary *dict =@{NSForegroundColorAttributeName : [UIColor whiteColor],
                              
                              NSShadowAttributeName : shadow};
        
        [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
        
        [barButtonItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
        
    }
    
    //修改返回按钮样式
    [barButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"back_white"]
                                       forState:UIControlStateNormal
                                     barMetrics:UIBarMetricsCompact];
    
    // 5.设置状态栏样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//重写返回按钮

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem ==nil && self.viewControllers.count >1) {
        
        viewController.navigationItem.leftBarButtonItem = [self creatBackButton];
    }
}

-(UIBarButtonItem *)creatBackButton
{
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(10, 2, 30, 30);
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
}

//- (void)navigationItemInit:(UIViewController*)viewController
//{
//    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,40,SCREENFRAME_SIZE_WIDTH/2,44)];
//    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
//    titleLabel.font            = [UIFont boldSystemFontOfSize:16];  //设置文本字体与大小
//    titleLabel.textColor       = [UIColor whiteColor];  //设置文本颜色
//    titleLabel.textAlignment   = NSTextAlignmentCenter;
//    viewController.navigationItem.titleView = titleLabel;
//}

//#pragma mark - presentViewController && pushViewController method
//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag
//                   completion:(void (^)(void))completion
//{
//    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
//    // 添加返回
//    UINavigationController *nav = (UINavigationController*)viewControllerToPresent;
//    if ([self.viewControllers count] > 1){
//        if (nav.topViewController.navigationItem.leftBarButtonItem == nil){
//            nav.topViewController.navigationItem.leftBarButtonItem =
//            [self navBarItemWithTarget:self
//                                action:@selector(dismissLeftBtnPress:)
//                             imageName:@"icon_return.png"];
//        }
//        if (nav.topViewController.navigationItem.rightBarButtonItem == nil)
//        {
//            nav.topViewController.navigationItem.rightBarButtonItem = [self navBarItemWithTarget:self action:@selector(rightBtnPressed:) imageName:@"icon_personal.png"];
//        }
//        [self navigationItemInit:nav.topViewController];
//        [self navigationItemInit:nav.topViewController];
//    }
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [super pushViewController:viewController animated:animated];
//    
//    // 添加返回
//    if ([self.viewControllers count] > 1){
//        if (viewController.navigationItem.leftBarButtonItem == nil){
//            viewController.navigationItem.leftBarButtonItem =
//            [self navBarItemWithTarget:self
//                                action:@selector(backBtnPressed:)
//                             imageName:@"icon_return.png"];
//        }
//        if (viewController.navigationItem.rightBarButtonItem == nil)
//        {
//            viewController.navigationItem.rightBarButtonItem =
//            [self navBarItemWithTarget:self
//                                action:@selector(rightBtnPressed:)
//                             imageName:@"icon_personal.png"];
//        }
//        
//        [self navigationItemInit:viewController];
//    }
//}


-(void)popSelf
{
    [self popViewControllerAnimated:YES];
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
