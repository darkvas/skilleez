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

- (void)didSkiilleSelect: (SkilleeModel*) skillee;
- (void)didProfileSelect:(NSString*)profileId;

@end


@interface SimpleTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezCommentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImg;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (nonatomic,strong) id delegate;

- (void)setSkilleezCell:(SimpleTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag;

@end
