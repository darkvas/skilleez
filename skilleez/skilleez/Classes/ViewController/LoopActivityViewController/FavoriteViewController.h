//
//  FavoriteViewController.h
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableCell.h"

@interface FavoriteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, SimpleCellDelegate>

- (id)initWithParent:(UIViewController *)parentController;

@end
