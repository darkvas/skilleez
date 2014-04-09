//
//  SkilleezListViewController.h
//  skilleez
//
//  Created by Vasya on 4/9/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableCell.h"

@interface SkilleezListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SimpleCellDelegate>

- (id)initWithUserId:(NSString *)userId;

@end
