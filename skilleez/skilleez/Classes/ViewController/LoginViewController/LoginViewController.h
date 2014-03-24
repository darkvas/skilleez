//
//  LoginViewController.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
