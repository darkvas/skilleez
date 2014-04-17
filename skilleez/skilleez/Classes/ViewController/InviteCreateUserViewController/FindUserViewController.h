//
//  FindUserViewController.h
//  skilleez
//
//  Created by Vasya on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileInfo.h"
#import "CustomAlertView.h"

@interface FindUserViewController : UIViewController <CustomIOS7AlertViewDelegate>

- (id)initWithProfile:(ProfileInfo *)profileInfo;

@end
