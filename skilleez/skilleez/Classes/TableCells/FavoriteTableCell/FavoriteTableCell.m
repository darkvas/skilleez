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

- (void)awakeFromNib
{
    [[CellFiller sharedInstance] setSkilleezCell:self];
}

- (void)setSkilleezData:(FavoriteTableCell *)cell andSkilleez:(SkilleeModel *)element andTag:(NSInteger)tag
{
    skilleeModel = element;
    [[CellFiller sharedInstance] setSkilleezData:cell andSkilleez:element andTag:tag];
}

- (IBAction)removeFromFavorites:(id)sender
{
    CustomAlertView *alert = [CustomAlertView new];
    [alert setDefaultContainerView:@"Are you sure you want to remove this skilleez from favorites?"];
    alert.alpha = 0.95;
    [alert setDelegate:self];
    [alert setUseMotionEffects:YES];
    [alert show];
}

- (void)selectProfile:(UIGestureRecognizer*)recognizer
{
    [self.delegate didProfileSelect:skilleeModel.UserId];
}

#pragma mark - CustomIOS7AlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[NetworkManager sharedInstance] postRemoveFromFavorites:skilleeModel.Id withCallBack:^(RequestResult *requestResult) {
            if(requestResult.isSuccess) {
                [self.delegate didSkiilleSelect:skilleeModel];
            } else {
                NSLog(@"Failed remove from Favorites: %@, error: %@", skilleeModel.Id, requestResult.error);
            }
        }];
    }
    [alertView close];
}

@end
