//
//  MoreButtonTableCell.h
//  skilleez
//
//  Created by Hedgehog on 18.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableItem.h"
#import "UIFont+DefaultFont.h"

@interface MoreButtonTableCell : UITableViewCell

- (void)fillCell:(MoreButtonTableCell *)cell withItem:(TableItem *)item;

@end
