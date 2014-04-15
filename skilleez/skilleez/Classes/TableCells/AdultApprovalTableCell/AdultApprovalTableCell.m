//
//  SkilleezTableCell.m
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "AdultApprovalTableCell.h"
#import "CellFiller.h"

@interface AdultApprovalTableCell()
{
    SkilleeModel *skillee;
}

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezCommentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImg;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

- (IBAction)showSkillee:(id)sender;

@end

@implementation AdultApprovalTableCell

- (void)awakeFromNib
{
    [[CellFiller sharedInstance] setSkilleezCell:self];
}

- (void)setSkilleezData:(AdultApprovalTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag
{
    skillee = element;
    [[CellFiller sharedInstance] setSkilleezData:cell andSkilleez:element andTag:tag];
}

- (IBAction)showSkillee:(id)sender
{
    [self.delegate didSkiilleSelect: skillee];
}

@end
