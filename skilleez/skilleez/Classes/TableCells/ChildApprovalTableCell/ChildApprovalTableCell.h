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

@interface ChildApprovalTableCell : SimpleTableCell

- (void)setSkilleezData:(SimpleTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag;

@end
