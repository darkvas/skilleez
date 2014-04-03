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
    CATransition* transition = [CATransition animation];
    [transition setDuration:0.3];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.fillMode = kCAFillModeBoth;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [viewController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerFromLeft:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    transition.fillMode = kCAFillModeBoth;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self popViewControllerAnimated:NO];
}

- (void)pushViewControllerCustom:(UIViewController *)viewController
{
    viewController.view.frame = CGRectMake(-320, 0, 320, 568);
    viewController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    viewController.view.layer.shadowOffset = CGSizeMake(15.f,0.0f);
    viewController.view.layer.shadowOpacity = 0.7f;
    viewController.view.layer.shadowRadius = 15.0f;
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = viewController.view.frame;
         frame.origin.x = 0;
         viewController.view.frame = frame;
    } completion:^(BOOL finished) {
        for (UIViewController *ctr in self.viewControllers) {
            NSLog(@"%@", ctr);
        }
    }];
}

- (void)popViewControllerCustom
{
    UIViewController *ui = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    UIViewController *cur = self.visibleViewController;
    ui.view.frame = CGRectMake(-320, 0, 320, 568);
    ui.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    ui.view.layer.shadowOffset = CGSizeMake(15.f,0.0f);
    ui.view.layer.shadowOpacity = 0.7f;
    ui.view.layer.shadowRadius = 15.0f;
    [self addChildViewController:ui];
    [self.view addSubview:ui.view];
    /*for (UIViewController *ctr in self.viewControllers) {
        NSLog(@"%@", ctr);
    }*/
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = ui.view.frame;
        frame.origin.x = 0;
        ui.view.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                [cur removeFromParentViewController];
                [cur.view removeFromSuperview];
                /*NSArray *ar = self.viewControllers;
                NSMutableArray *mut = [NSMutableArray arrayWithArray:ar];
                [mut removeObject:cur];
                self.viewControllers = [NSArray arrayWithArray:mut];*/
            }
            for (UIViewController *ctr in self.viewControllers) {
                NSLog(@"%@", ctr);
            }
    }];

}

@end
