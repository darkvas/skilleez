//
//  ProfileViewController.m
//  skilleez
//
//  Created by Roma on 3/26/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "ProfileViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"

#define CORNER_RADIUS 5.f
#define BORDER_WIDTH 2.f

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
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"My profile" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
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

- (void)done
{
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
    self.userColorImg.layer.borderWidth = BORDER_WIDTH;
    self.userColorImg.layer.cornerRadius = CORNER_RADIUS;
    self.userSportImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userSportImg.layer.masksToBounds = YES;
    self.userSportImg.layer.borderWidth = BORDER_WIDTH;
    self.userSportImg.layer.cornerRadius = CORNER_RADIUS;
    self.userMusicImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userMusicImg.layer.masksToBounds = YES;
    self.userMusicImg.layer.borderWidth = BORDER_WIDTH;
    self.userMusicImg.layer.cornerRadius = CORNER_RADIUS;
    self.userSubjectImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userSubjectImg.layer.masksToBounds = YES;
    self.userSubjectImg.layer.borderWidth = BORDER_WIDTH;
    self.userSubjectImg.layer.cornerRadius = CORNER_RADIUS;
    self.userFoodImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.userFoodImg.layer.masksToBounds = YES;
    self.userFoodImg.layer.borderWidth = BORDER_WIDTH;
    self.userFoodImg.layer.cornerRadius = CORNER_RADIUS;
}

@end
