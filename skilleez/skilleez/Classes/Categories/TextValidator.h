//
//  TextValidator.h
//  skilleez
//
//  Created by Vasya on 5/5/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextValidator : NSObject

+ (BOOL)allowInputCharForAccount:(UITextField *) textField withNewString:(NSString*) string withRange:(NSRange)range;
+ (BOOL)allowInputCharForPassword:(UITextField *) textField withNewString:(NSString*) string withRange:(NSRange)range;
+ (BOOL)allowInputCharForText:(NSString*) string;
+ (BOOL)allowInputCharForEmail: (UITextField *) textField withNewString:(NSString*) string withRange:(NSRange)range;

+ (BOOL)validateEmailWithString:(NSString *) email;

@end
