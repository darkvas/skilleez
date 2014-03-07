//
//  LoginViewController.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField* tfUsername;
    IBOutlet UITextField* tfPassword;
}

-(IBAction) loginPressed:(UIButton*) sender;

@end
