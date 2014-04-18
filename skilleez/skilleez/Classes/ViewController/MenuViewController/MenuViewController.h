//
//  MenuViewController.h
//  skilleez
//
//  Created by Roma on 3/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

- (id)initWithController:(UIViewController *)loop;

@end
