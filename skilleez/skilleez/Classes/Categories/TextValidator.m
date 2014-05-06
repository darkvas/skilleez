//
//  TextValidator.m
//  skilleez
//
//  Created by Vasya on 5/5/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "TextValidator.h"

const int kMaxLoginLength = 50;
const int kMaxEmailLength = 100;
const int kMaxTextLength = 250;

static NSString *allowedLoginChars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
static NSString *allowedPasswordChars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_+-=,.@";
static NSString *allowedEmailChars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789._+-@";
static NSString *allowedTextChars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ,.!?:;_%+-=*/#()[]<>&$@";

@implementation TextValidator

+ (BOOL)allowInputCharForAccount:(UITextField *) textField withNewString:(NSString*) string withRange:(NSRange)range
{
    return [self isAllowedInput:textField
                  withNewString:string
                      withRange:range
                  withMaxLength:kMaxLoginLength
               withAllowedChars:allowedLoginChars];
}

+ (BOOL)isAllowedInput:(UITextField *) textField withNewString:(NSString*) string withRange:(NSRange)range withMaxLength: (int) maxLength withAllowedChars: (NSString *) allowedChars
{
    //MaxLenght
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    //AllowedCharacters
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:allowedChars] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (newLength <= maxLength || returnKey) && [string isEqualToString:filtered];
}


+ (BOOL)allowInputCharForPassword: (UITextField *) textField withNewString:(NSString*) string withRange:(NSRange)range
{
    return [self isAllowedInput:textField
                  withNewString:string
                      withRange:range
                  withMaxLength:kMaxLoginLength
               withAllowedChars:allowedPasswordChars];
}

+ (BOOL)allowInputCharForText: (UITextField *) textField withNewString:(NSString*) string withRange:(NSRange)range
{
    return [self isAllowedInput:textField
                  withNewString:string
                      withRange:range
                  withMaxLength:kMaxTextLength
               withAllowedChars:allowedTextChars];
}

+ (BOOL)allowInputCharForEmail: (UITextField *) textField withNewString:(NSString*) string withRange:(NSRange)range
{
    return [self isAllowedInput:textField
                  withNewString:string
                      withRange:range
                  withMaxLength:kMaxEmailLength
               withAllowedChars:allowedEmailChars];
}

+ (BOOL)validateEmailWithString:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
