//
//  AppDelegate.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "AppDelegate.h"

#import "SplashViewController.h"
#import "UIFont+DefaultFont.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.navigationCtrl = [[UINavigationController alloc] init];
    self.window.rootViewController = self.navigationCtrl;
    SplashViewController *login = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    [self.navigationCtrl pushViewController:login animated:NO];
    UIColor* navBarColor = [UIColor colorWithRed:242.0/255.0 green:185.0/255.0 blue:32.0/255.0 alpha:1.f];
    UINavigationBar *navigationBar = self.navigationCtrl.navigationBar;
    
    navigationBar.barTintColor = navBarColor;
    navigationBar.translucent = YES;
    navigationBar.opaque = YES;
    navigationBar.barStyle = UIBarStyleBlack;
    
    CALayer *navBackLayer =  [CALayer layer];
    navBackLayer.backgroundColor = [navBarColor CGColor];
    navBackLayer.frame = CGRectMake(0.0, -20.0, self.navigationCtrl.navigationBar.frame.size.width, self.navigationCtrl.navigationBar.frame.size.height + 20);
    navBackLayer.zPosition = -1;
    [navigationBar.layer addSublayer:navBackLayer];
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundColor:navBarColor];
    
    [self.navigationCtrl setNavigationBarHidden:YES animated:NO];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)cutomizeNavigationBar:(UIViewController *)this withTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightButton:(BOOL)rightButton rightTitle:(NSString *)rightTitle
{
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont getDKCrayonFontWithSize:24];
    titleLbl.textColor = [UIColor whiteColor];
    this.navigationItem.titleView = titleLbl;
    if (rightButton) {
        this.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self makeRightButtonWithTitle:rightTitle view:this]];
    }
    this.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self makeLeftButtonWithTitle:leftTitle view:this]];
    //this.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.94 green:0.72 blue:0.12 alpha:1.f];
    /*UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    back.backgroundColor = [UIColor colorWithRed:0.94 green:0.72 blue:0.12 alpha:1.f];
    [this.navigationController.navigationBar.layer addSublayer:back.layer];*/
    this.navigationController.navigationBarHidden = NO;
}

- (UIButton *)makeLeftButtonWithTitle:(NSString *)title view:(UIViewController *)this
{
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [cancelBtn setImage:[UIImage imageNamed:@"back_BTN.png"] forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"back_BTN_press.png"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:title forState:UIControlStateNormal];
    [cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cancelBtn addTarget:this action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [cancelBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:21]];
    return cancelBtn;
}

- (UIButton *)makeRightButtonWithTitle:(NSString *)title view:(UIViewController *)this
{
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [doneBtn setTitle:title forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [doneBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:21]];
    [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [doneBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneBtn addTarget:this action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    return doneBtn;
}

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([[self.window.subviews.lastObject class].description isEqualToString:@"MPSwipableView"] && self.counter != 3) {
        self.counter++;
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        self.counter = 0;
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
