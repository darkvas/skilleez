//
//  SkilleezTableCell.m
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SimpleTableCell.h"
#import "CellFiller.h"

@interface SimpleTableCell()
{
    SkilleeModel *skilleeModel;
}

- (IBAction)showSkille:(id)sender;
- (void)selectProfile:(UIGestureRecognizer *)recognizer;

@end

@implementation SimpleTableCell

- (void)setSkilleezCell:(SimpleTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag
{
    skilleeModel = element;
    [[CellFiller sharedInstance] setSkilleezCell:cell andSkilleez:element andTag:tag];
    cell.detailBtn.tag = tag;
}

#pragma mark - SimpleCellDelegate

- (IBAction)showSkille:(id)sender
{
    [self.delegate didSkiilleSelect:((UIButton *)sender).tag];
}

- (void)selectProfile:(UIGestureRecognizer *)recognizer
{
    [self.delegate didProfileSelect: skilleeModel.UserId];
}

@end
