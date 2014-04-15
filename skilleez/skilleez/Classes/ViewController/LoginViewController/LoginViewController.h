//
//  LoginViewController.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

extern const NSString *REGISTER_URL;
extern const NSString *FORGOT_RASSWORD_URL;


- (void) getAccountInformation;

@end
