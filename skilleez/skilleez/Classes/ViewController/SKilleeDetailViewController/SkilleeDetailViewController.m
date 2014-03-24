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
#import "LoopActivityViewController.h"
#import "NetworkManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SkilleeDetailViewController () {
    SkilleeModel *skillee;
    BOOL enabledApprove;
}
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
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

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)deny:(id)sender;
- (IBAction)approve:(id)sender;
- (IBAction)favorite:(id)sender;
- (IBAction)tattle:(id)sender;

@end

@implementation SkilleeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSkillee:(SkilleeModel *)skilleeEl andApproveOpportunity:(BOOL)enabled
{
    if (self = [super init]) {
        skillee = skilleeEl;
        enabledApprove = enabled;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCellFonts];
    [self setSkillee];
    if (!enabledApprove) {
        [self showDisabledButtons];   
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCellFonts
{
    [self.userNameLbl setFont:[UIFont getDKCrayonFontWithSize:25]];
    [self.cancelBtn setFont:[UIFont getDKCrayonFontWithSize:21]];
    [self.doneBtn setFont:[UIFont getDKCrayonFontWithSize:21]];
    [self.skilleeDateLbl setFont:[UIFont getDKCrayonFontWithSize:16]];
    [self.skilleeTitleLbl setFont:[UIFont getDKCrayonFontWithSize:35]];
    [self.skilleeCommentLbl setFont:[UIFont getDKCrayonFontWithSize:21]];
    [self.denyBtn setFont:[UIFont getDKCrayonFontWithSize:19]];
    [self.approveBtn setFont:[UIFont getDKCrayonFontWithSize:19]];
    [self.denyDisabledBtn setFont:[UIFont getDKCrayonFontWithSize:19]];
    [self.approveDisabledBtn setFont:[UIFont getDKCrayonFontWithSize:19]];
    [self.favoriteBtn setFont:[UIFont getDKCrayonFontWithSize:19]];
    [self.tattleBtn setFont:[UIFont getDKCrayonFontWithSize:19]];
    self.userAvatarImg.layer.cornerRadius = 28.0;
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvatarImg.layer.borderWidth = 3.0;
    self.denyBtn.layer.borderWidth = 1.0;
    self.denyBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.approveBtn.layer.borderWidth = 1.0;
    self.approveBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.denyDisabledBtn.layer.borderWidth = 1.0;
    self.denyDisabledBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.approveDisabledBtn.layer.borderWidth = 1.0;
    self.approveDisabledBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.favoriteBtn.layer.borderWidth = 1.0;
    self.favoriteBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.tattleBtn.layer.borderWidth = 1.0;
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
    [self.userAvatarImg setImageWithURL:[NSURL URLWithString:skillee.UserAvatarUrl]];
    if ([self isVideo:skillee.MediaUrl]) {
        _player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:skillee.MediaUrl]];
        _player.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [_player.view setFrame:self.skilleeMediaImg.frame];
        [_player.moviePlayer setControlStyle:MPMovieControlStyleDefault];
        _player.moviePlayer.shouldAutoplay = NO;
        [self.view addSubview:_player.view];
        [_player.moviePlayer prepareToPlay];
    } else {
        [self.skilleeMediaImg setImageWithURL:[NSURL URLWithString:skillee.MediaUrl]];
    }
    self.skilleeTitleLbl.text = skillee.Title;
    self.skilleeCommentLbl.text = skillee.Comment;
}

- (BOOL)isVideo:(NSString *)url
{
    return [url hasSuffix:@"mp4"];
}

- (void)showDisabledButtons {
    self.denyDisabledBtn.hidden = NO;
    self.approveDisabledBtn.hidden = NO;
    self.approveBtn.hidden = YES;
    self.denyBtn.hidden = YES;
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender {
}

- (IBAction)deny:(id)sender {
}

- (IBAction)approve:(id)sender {
}

- (IBAction)favorite:(id)sender {
    [[NetworkManager sharedInstance] postAddToFavorites:skillee.Id success:^{
        NSLog(@"Success add to Favorites: %@", skillee.Id);
    } failure:^(NSError *error) {
        NSLog(@"Failed add to Favorites: %@, error: %@", skillee.Id, error);
    }];
}

- (IBAction)tattle:(id)sender {
    [[NetworkManager sharedInstance] postMarkAsTatle:skillee.Id success:^{
        NSLog(@"Success mark as Tatle: %@", skillee.Id);
    } failure:^(NSError *error) {
        NSLog(@"Failed mark as Tatle: %@, error: %@", skillee.Id, error);
    }];
}
@end
