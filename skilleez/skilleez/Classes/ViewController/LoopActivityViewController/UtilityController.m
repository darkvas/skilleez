//
//  UtilityController.m
//  skilleez
//
//  Created by Hedgehog on 17.04.14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "UtilityController.h"

@implementation UtilityController

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (BOOL)isArrayEquals:(NSArray *)ar1 toOther:(NSArray *)ar2
{
    if ([ar1 count] != [ar2 count]) return NO;
    for (int i = 0; i < [ar1 count]; i++) {
        if (![[ar1 objectAtIndex:i] isEqual:[ar2 objectAtIndex:i]]) {
            return NO;
        }
    }
    return YES;
}

- (void)profileSelect:(NSString *)profileId onController:(UIViewController *)controller
{
    FamilyMemberModel *familyMember = [self findInFriends:profileId];
    if (familyMember)
        if (familyMember.IsAdult) {
            AdultProfileViewController *profilePermissionView = [AdultProfileViewController new];
            profilePermissionView.familyMember = familyMember;
            [controller.navigationController pushViewControllerCustom:profilePermissionView];
        } else {
            ChildProfileViewController *childProfileView = [ChildProfileViewController new];
            childProfileView.showFriendsFamily = YES;
            childProfileView.familyMember = familyMember;
            [controller.navigationController pushViewControllerCustom:childProfileView];
        }
    else
        if ([profileId isEqualToString:[UserSettingsManager sharedInstance].userInfo.UserID]) {
            EditProfileViewController *editProfileView = [EditProfileViewController new];
            [controller.navigationController pushViewController:editProfileView animated:YES];
        } else {
            ChildProfileViewController *defaultChildProfileView = [ChildProfileViewController new];
            defaultChildProfileView.showFriendsFamily = YES;
            [controller.navigationController pushViewControllerCustom:defaultChildProfileView];
        }
}

- (FamilyMemberModel *)findInFriends:(NSString *)profileId
{
    for (FamilyMemberModel *member in [UserSettingsManager sharedInstance].friendsAndFamily) {
        if ([member.Id isEqualToString:profileId])
            return member;
    }
    return nil;
}

- (void)showFailureAlert:(NSError *)error withCaption:(NSString *)caption
{
    NSString* message = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:caption message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)showFailureAlert:(NSError *)error withCaption:(NSString *)caption withIndicator:(UIActivityIndicatorView *) activityIndicator
{
    [activityIndicator stopAnimating];
    NSString *message = error.userInfo[NSLocalizedDescriptionKey];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:caption message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)setBadgeValue:(int)value forController:(HomeViewController *)homeController
{
    if (value == 0) {
        homeController.badge.hidden = YES;
    } else {
        homeController.badge.hidden = NO;
        homeController.badge.text = [NSString stringWithFormat:@"%i", value];
    }
}

- (void)showAnotherViewController:(UIViewController *)child
{
    HomeViewController *home = (HomeViewController *)child.navigationController.visibleViewController;
    [home.currentViewController.view removeFromSuperview];
    [home.currentViewController removeFromParentViewController];
    child.view.hidden = NO;
    home.currentViewController = child;
}

@end