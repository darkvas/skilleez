//
//  UINavigationController+Push.m
//  skilleez
//
//  Created by Roma on 4/1/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "UINavigationController+Push.h"

@implementation UINavigationController (Push)

- (void)pushViewControllerFromLeft:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerFromLeft:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self popViewControllerAnimated:NO];
}

- (void)pushViewControllerCustom:(UIViewController *)viewController
{
    viewController.view.frame = CGRectMake(-320, 0, 320, 568);
    [self.navigationController addChildViewController:viewController];
    [self.navigationController.view addSubview:viewController.view];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = viewController.view.frame;
        frame.origin.x = 0;
        viewController.view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)popViewControllerCustom
{
    UIViewController *ui = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    UIViewController *cur = self.navigationController.visibleViewController;
    ui.view.frame = CGRectMake(-320, 0, 320, 568);
    [self.navigationController addChildViewController:ui];
    [self.navigationController.view addSubview:ui.view];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = ui.view.frame;
        frame.origin.x = 0;
        ui.view.frame = frame;
        } completion:^(BOOL finished) {
            [cur removeFromParentViewController];
            [cur.view removeFromSuperview];
    }];
}

@end
