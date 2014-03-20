//
//  SkilleezTableCell.h
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkilleeModel.h"

@protocol SimpleCellDelegate <NSObject>
@required
- (void)didSkiilleSelect:(NSInteger) tag;
@end


@interface SimpleTableCell : UITableViewCell

@property (nonatomic,strong) id delegate;

- (void)setSkilleezCell:(SimpleTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag;

@end
