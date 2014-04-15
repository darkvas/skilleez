//
//  LoopActivityViewController.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableCell.h"

extern const int LOOP;
extern const int APPROVES;
extern const int FAVORITES;
extern const int NUMBER_OF_ITEMS;

@interface LoopActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SimpleCellDelegate>

- (void)hideMenu;
- (void)showMenu;

@end
