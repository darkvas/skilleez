//
//  ProfileViewController.m
//  skilleez
//
//  Created by Roma on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UIFont+DefaultFont.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UIImageView *userColorImg;
@property (weak, nonatomic) IBOutlet UIImageView *userSportImg;
@property (weak, nonatomic) IBOutlet UIImageView *userSubjectImg;
@property (weak, nonatomic) IBOutlet UIImageView *userMusicImg;
@property (weak, nonatomic) IBOutlet UIImageView *userFoodImg;
@property (weak, nonatomic) IBOutlet UILabel *userDescLbl;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AppDelegate alloc] cutomizeNavigationBar:self withTitle:@"My profile" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self customize];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customize
{
    self.userDescLbl.font = [UIFont getDKCrayonFontWithSize:21.f];
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = 5.f;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userColorImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userColorImg.layer.masksToBounds = YES;
    self.userColorImg.layer.borderWidth = 2.f;
    self.userColorImg.layer.cornerRadius = 5.f;
    self.userSportImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userSportImg.layer.masksToBounds = YES;
    self.userSportImg.layer.borderWidth = 2.f;
    self.userSportImg.layer.cornerRadius = 5.f;
    self.userMusicImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userMusicImg.layer.masksToBounds = YES;
    self.userMusicImg.layer.borderWidth = 2.f;
    self.userMusicImg.layer.cornerRadius = 5.f;
    self.userSubjectImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userSubjectImg.layer.masksToBounds = YES;
    self.userSubjectImg.layer.borderWidth = 2.f;
    self.userSubjectImg.layer.cornerRadius = 5.f;
    self.userFoodImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userFoodImg.layer.masksToBounds = YES;
    self.userFoodImg.layer.borderWidth = 2.f;
    self.userFoodImg.layer.cornerRadius = 5.f;
}

-(void) done
{
}

@end
