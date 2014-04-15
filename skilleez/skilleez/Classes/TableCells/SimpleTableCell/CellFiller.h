//
//  CellFiller.h
//  skilleez
//
//  Created by Roma on 4/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleTableCell.h"
#import "SkilleeModel.h"
#import "ChildApprovalTableCell.h"

@interface CellFiller : NSObject

+ (instancetype)sharedInstance;
- (void)setSkilleezData:(SimpleTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag;
- (void)setSkilleezCell:(SimpleTableCell *)cell;

@end
