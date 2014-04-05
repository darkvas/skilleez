//
//  ActivityIndicatorController.m
//  skilleez
//
//  Created by Vasya on 4/4/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ActivityIndicatorController.h"

@implementation ActivityIndicatorController
{
    UIActivityIndicatorView *activityIndicator;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startActivityIndicator: (UIViewController*) viewController
{
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setBackgroundColor:[UIColor whiteColor]];
    [activityIndicator setAlpha:0.7];
    activityIndicator.center = CGPointMake(viewController.view.frame.size.width / 2.0, viewController.view.frame.size.height / 2.0);
    [viewController.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
}

- (void)stopActivityIndicator
{
    if (activityIndicator) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }
}

@end
