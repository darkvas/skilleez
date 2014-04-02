//
//  LoopActivityViewController.h
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableCell.h"

@interface LoopActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SimpleCellDelegate>

- (void)hideMenu;
- (void)showMenu;
- (IBAction)loadTop:(id)sender;

@end
