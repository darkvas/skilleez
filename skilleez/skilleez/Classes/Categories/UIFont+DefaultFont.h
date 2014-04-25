//
//  UIFont+DefaultFont.h
//  skilleez
//
//  Created by Roma on 3/17/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Constants.h"

extern const float LABEL_SMALL;
extern const float LABEL_MEDIUM;
extern const float LABEL_BIG;

extern const float BUTTON_SMALL;
extern const float BUTTON_MEDIUM;
extern const float BUTTON_BIG;

extern const float TEXTVIEW_SMALL;
extern const float TEXTVIEW_MEDIUM;
extern const float TEXTVIEW_BIG;

@interface UIFont (DefaultFont)

+ (UIFont *)getDKCrayonFontWithSize:(CGFloat)size;

@end
