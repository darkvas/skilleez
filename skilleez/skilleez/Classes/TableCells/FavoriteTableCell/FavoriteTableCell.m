//
//  SkilleezTableCell.m
//  skilleez
//
//  Created by Roma on 3/14/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "FavoriteTableCell.h"
#import "NetworkManager.h"
#import "CellFiller.h"

@interface FavoriteTableCell()
{
    SkilleeModel *skilleeModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleezCommentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImg;
@property (weak, nonatomic) IBOutlet UIButton *removeFavBtn;

- (IBAction) removeFromFavorites:(id)sender;

@end

@implementation FavoriteTableCell

- (void)setSkilleezCell:(FavoriteTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag
{
    skilleeModel = element;
    [[CellFiller sharedInstance] setSkilleezCell:cell andSkilleez:element andTag:tag];
}

- (IBAction)removeFromFavorites:(id)sender
{
    [[NetworkManager sharedInstance] postRemoveFromFavorites:skilleeModel.Id success:^{
         [self.delegate didSkiilleSelect:((UIButton *)sender).tag];
    } failure:^(NSError *error) {
        NSLog(@"Failed remove from Favorites: %@, error: %@", skilleeModel.Id, error);
    }];
}

- (void)selectProfile:(UIGestureRecognizer*)recognizer
{
    [self.delegate didProfileSelect:skilleeModel.UserId];
}

@end
