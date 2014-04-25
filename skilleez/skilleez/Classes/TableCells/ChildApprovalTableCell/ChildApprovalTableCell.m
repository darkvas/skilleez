//
//  SkilleezTableCell.m
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ChildApprovalTableCell.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "CellFiller.h"

@interface ChildApprovalTableCell()
{
    SkilleeModel *skilleeModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezCommentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImg;
@property (weak, nonatomic) IBOutlet UILabel *waitingForApprovalLbl;

- (IBAction)deleteSkillee:(id)sender;
- (void)selectProfile:(UIGestureRecognizer *)recognizer;

@end

@implementation ChildApprovalTableCell

- (void)awakeFromNib
{
    [[CellFiller sharedInstance] setSkilleezCell:self];
}

- (void)setSkilleezData:(ChildApprovalTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag
{
    skilleeModel = element;
    [[CellFiller sharedInstance] setSkilleezData:cell andSkilleez:element andTag:tag];
    [cell.waitingForApprovalLbl setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
}

- (IBAction)deleteSkillee:(id)sender
{
    [[NetworkManager sharedInstance] postRemoveSkillee:skilleeModel.Id withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            [self.delegate didSkiilleSelect:skilleeModel];
        } else {
            NSLog(@"Delete Skillee error: %@", requestResult.error);
        }
    }];
}

- (void)selectProfile:(UIGestureRecognizer*)recognizer
{
    [self.delegate didProfileSelect:skilleeModel.UserId];
}

@end
