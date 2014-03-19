//
//  SkilleezTableCell.h
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkilleeModel.h"
#import "SimpleTableCell.h"

@interface FavoriteTableCell : SimpleTableCell

- (void)setSkilleezCell:(FavoriteTableCell *)cell andSkilleez:(SkilleeModel *)element;

@end
