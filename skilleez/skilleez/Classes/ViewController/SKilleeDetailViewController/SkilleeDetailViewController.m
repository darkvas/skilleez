//
//  SkilleeDetailViewController.m
//  skilleez
//
//  Created by Roma on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "SkilleeDetailViewController.h"
#import "SimpleTableCell.h"
#import "UIFont+DefaultFont.h"
#import "HomeViewController.h"
#import "NetworkManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
#import "NavigationBarView.h"
#import "UINavigationController+Push.h"
#import "ActivityIndicatorController.h"

const int BUTTON_FONT_SIZE_SD = 19;
const float BUTTON_BORDER_WIDTH_SD = 1.0;

typedef enum {
    SkilleeActionNone,
    SkilleeActionDeny,
    SkilleeActionApprove
} SkilleeAction;

@interface SkilleeDetailViewController () {
    SkilleeModel *skillee;
    BOOL enabledApprove;
    SkilleeAction skilleeAction;
}

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleeDateLbl;
@property (weak, nonatomic) IBOutlet UIImageView *skilleeMediaImg;
@property (weak, nonatomic) IBOutlet UILabel *skilleeTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleeCommentLbl;
@property (weak, nonatomic) IBOutlet UIButton *denyBtn;
@property (weak, nonatomic) IBOutlet UIButton *approveBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *tattleBtn;
@property (weak, nonatomic) IBOutlet UIButton *denyDisabledBtn;
@property (weak, nonatomic) IBOutlet UIButton *approveDisabledBtn;
@property (strong, nonatomic) MPMoviePlayerViewController *player;
@property (strong, nonatomic) UIViewController *fullScreenImage;

- (IBAction)deny:(id)sender;
- (IBAction)approve:(id)sender;
- (IBAction)favorite:(id)sender;
- (IBAction)tattle:(id)sender;
- (IBAction)showImage:(id)sender;

@end

@implementation SkilleeDetailViewController

- (id)initWithSkillee:(SkilleeModel *)skilleeEl andApproveOpportunity:(BOOL)enabled
{
    if (self = [super init]) {
        skillee = skilleeEl;
        enabledApprove = enabled;
        skilleeAction = SkilleeActionNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    [self setCellFonts];
    [self setSkillee];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    if (!enabledApprove) {
        [self showDisabledButtons];   
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_player.moviePlayer prepareToPlay];
}

#pragma mark - Class methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    [self.navigationController popViewControllerCustom];
}

- (void)done
{
    switch (skilleeAction) {
        case SkilleeActionApprove:
            [self approveSkilleeAndExit:YES];
            break;
        case SkilleeActionDeny:
            [self approveSkilleeAndExit:NO];
            break;
        default:
            [self.navigationController popViewControllerCustom];
            break;
    }
}

- (void)approveSkilleeAndExit:(BOOL)approve
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postApproveOrDenySkillee:skillee.Id isApproved:approve withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            NSLog(@"Success %@: %@", approve ? @"approved" : @"denied", skillee.Id);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            [self.navigationController popViewControllerCustom];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSString* title = [NSString stringWithFormat:@"%@ failed", approve ? @"Approve" : @"Deny"];
            NSString* message = requestResult.error.userInfo[NSLocalizedDescriptionKey];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
}

- (void)setCellFonts
{
    [self.userNameLbl setFont:[UIFont getDKCrayonFontWithSize:25]];
    [self.skilleeDateLbl setFont:[UIFont getDKCrayonFontWithSize:16]];
    [self.skilleeTitleLbl setFont:[UIFont getDKCrayonFontWithSize:35]];
    [self.skilleeCommentLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
    [self.denyBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_FONT_SIZE_SD]];
    [self.approveBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_FONT_SIZE_SD]];
    [self.denyDisabledBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_FONT_SIZE_SD]];
    [self.approveDisabledBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_FONT_SIZE_SD]];
    [self.favoriteBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_FONT_SIZE_SD]];
    [self.tattleBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_FONT_SIZE_SD]];
    self.userAvatarImg.layer.cornerRadius = 28.0;
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvatarImg.layer.borderWidth = 3.0;
    self.denyBtn.layer.borderWidth = BUTTON_BORDER_WIDTH_SD;
    self.denyBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.approveBtn.layer.borderWidth = BUTTON_BORDER_WIDTH_SD;
    self.approveBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.denyDisabledBtn.layer.borderWidth = BUTTON_BORDER_WIDTH_SD;
    self.denyDisabledBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.approveDisabledBtn.layer.borderWidth = BUTTON_BORDER_WIDTH_SD;
    self.approveDisabledBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.favoriteBtn.layer.borderWidth = BUTTON_BORDER_WIDTH_SD;
    self.favoriteBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tattleBtn.layer.borderWidth = BUTTON_BORDER_WIDTH_SD;
    self.tattleBtn.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)setSkillee
{
    self.userNameLbl.text = skillee.UserName;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterNoStyle];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:usLocale];
    self.skilleeDateLbl.text =[format stringFromDate:skillee.PostedDate];
    [self.userAvatarImg setImageWithURL:skillee.UserAvatarUrl];
    if ([self isVideo:[skillee.MediaUrl absoluteString]]) {
        _player = [[MPMoviePlayerViewController alloc] initWithContentURL:skillee.MediaUrl];
        _player.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [_player.view setFrame:self.skilleeMediaImg.frame];
        [_player.moviePlayer setControlStyle:MPMovieControlStyleDefault];
        _player.moviePlayer.shouldAutoplay = NO;
        [self.view addSubview:_player.view];
        [_player.moviePlayer prepareToPlay];
        _player.moviePlayer.fullscreen = YES;
    } else {
        [self.skilleeMediaImg setImageWithURL:skillee.MediaUrl];
    }
    self.skilleeTitleLbl.text = skillee.Title;
    self.skilleeCommentLbl.text = skillee.Comment;
    self.view.backgroundColor = skillee.Color;
}

- (BOOL)isVideo:(NSString *)url
{
    return [url hasSuffix:@"mp4"] || [url hasSuffix:@"3gp" ] || [url hasSuffix:@"mpeg"];
}

- (void)showDisabledButtons {
    self.denyDisabledBtn.hidden = NO;
    self.approveDisabledBtn.hidden = NO;
    self.approveBtn.hidden = YES;
    self.denyBtn.hidden = YES;
}

- (void)canApproveByAPI
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getCanApprove:skillee.Id withCallBack:^(RequestResult *requestReturn) {
        if (requestReturn.isSuccess) {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            BOOL canApprove = [((NSNumber*)requestReturn.firstObject) boolValue];
            NSLog(@"Can approve: %@", canApprove ? @"YES" : @"FALSE");
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSLog(@"Failed get can approve: %@, error: %@", skillee.Id, requestReturn.error);
        }
    }];
}

- (IBAction)deny:(id)sender {
    skilleeAction = SkilleeActionDeny;
}

- (IBAction)approve:(id)sender {
    skilleeAction = SkilleeActionApprove;
}

- (IBAction)favorite:(id)sender
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postAddToFavorites:skillee.Id withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            NSLog(@"Success add to Favorites: %@", skillee.Id);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [CustomAlertView new];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"Ok" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0.27 green:0.53 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
            alert.buttons = @[button];
            [alert setDefaultContainerView:@"You have added this skillee to your favorites"];
            alert.alpha = 0.95;
            [alert setDelegate:self];
            [alert setUseMotionEffects:YES];
            [alert show];
        } else {
            NSLog(@"Failed add to Favorites: %@, error: %@", skillee.Id, requestResult.error);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        }
    }];
}

- (IBAction)tattle:(id)sender
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postMarkAsTatle:skillee.Id withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            NSLog(@"Success mark as Tatle: %@", skillee.Id);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [CustomAlertView new];
            [alert setDefaultContainerView:@"You have added this skillee to tattles"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"Ok" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:0.27 green:0.53 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
            alert.buttons = @[button];
            alert.alpha = 0.95;
            [alert setDelegate:self];
            [alert setUseMotionEffects:YES];
            [alert show];
        } else {
            NSLog(@"Failed mark as Tatle: %@, error: %@", skillee.Id, requestResult.error);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        }
    }];
}

- (IBAction)showImage:(id)sender
{
    self.fullScreenImage = [[UIViewController alloc] init];
    self.fullScreenImage.view.backgroundColor = [UIColor lightGrayColor];
    self.fullScreenImage.view.userInteractionEnabled=YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 548)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.skilleeMediaImg.image;
    imageView.tag = 1;
    [self.fullScreenImage.view addSubview:imageView];
    float scale = self.skilleeMediaImg.image.size.height / 160;
    UIImage *image = [[UIImage alloc] initWithCGImage: self.skilleeMediaImg.image.CGImage scale: scale orientation: UIImageOrientationRight];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 548)];
    img.contentMode = UIViewContentModeCenter;
    img.image = image;
    img.tag = 2;
    img.hidden = YES;
    [self.fullScreenImage.view addSubview:img];
    UITapGestureRecognizer *modalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModalView)];
    [self.fullScreenImage.view addGestureRecognizer:modalTap];
    [self.navigationController pushViewController:self.fullScreenImage animated:YES];
}

- (void)dismissModalView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        for (UIView *view in self.fullScreenImage.view.subviews) {
            if (view.tag == 1) {
                view.hidden = YES;
            } else if (view.tag == 2) {
                view.hidden = NO;
            }
        }
    } else {
        for (UIView *view in self.fullScreenImage.view.subviews) {
            if (view.tag == 2) {
                view.hidden = YES;
            } else if (view.tag == 1) {
                view.hidden = NO;
            }
        }
    }
}

#pragma mark - CustomIOS7AlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView close];
}

@end
