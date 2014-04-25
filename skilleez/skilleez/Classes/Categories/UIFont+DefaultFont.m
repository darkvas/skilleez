//
//  UIFont+DefaultFont.m
//  skilleez
//
//  Created by Roma on 3/17/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "UIFont+DefaultFont.h"

const float LABEL_SMALL = 18.0;
const float LABEL_MEDIUM = 22.0;
const float LABEL_BIG = 32.0;

const float BUTTON_SMALL = 22.0;
const float BUTTON_MEDIUM = 24.0;
const float BUTTON_BIG = 32.0;

const float TEXTVIEW_SMALL = 18.0;
const float TEXTVIEW_MEDIUM = 24.0;
const float TEXTVIEW_BIG = 36.0;



@implementation UIFont (DefaultFont)

+ (UIFont *)getDKCrayonFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"DKCrayonCrumble" size:size];
}

@end
