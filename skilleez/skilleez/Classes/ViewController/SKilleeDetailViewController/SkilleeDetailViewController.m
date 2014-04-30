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
#import "TableItem.h"
#import "MoreButtonTableCell.h"

typedef enum {
    SkilleeActionNone,
    SkilleeActionDeny,
    SkilleeActionApprove
} SkilleeAction;

@interface SkilleeDetailViewController () {
    SkilleeModel *skillee;
    BOOL enabledApprove;//TODO: in future will be not needed when can approve by API will work
    SkilleeAction skilleeAction;
    NSMutableArray *buttons;
}

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *skilleeMediaImg;
@property (weak, nonatomic) IBOutlet UILabel *skilleeTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *skilleeCommentLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *more;
@property (strong, nonatomic) MPMoviePlayerViewController *player;
@property (strong, nonatomic) UIViewController *fullScreenImage;
@property (strong, nonatomic) IBOutlet UIView *rightMenu;
@property (weak, nonatomic) IBOutlet UIView *leftView;

- (void)deny;
- (void)approve;
- (void)favorite;
- (void)tattle;
- (IBAction)showImage:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)showMore:(id)sender;

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
    [self setCellFonts];
    [self setSkillee];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    buttons = [NSMutableArray arrayWithObjects:
               [[TableItem alloc] initWithName:@"APPROVE" image:[UIImage imageNamed:@"Thumb-up"] method:@"approve"],
               [[TableItem alloc] initWithName:@"DENY" image:[UIImage imageNamed:@"Thumb-down"] method:@"deny"],
               [[TableItem alloc] initWithName:@"FAVORITE" image:[UIImage imageNamed:@"Star2"] method:@"favorite"],
               [[TableItem alloc] initWithName:@"TATTLE" image:[UIImage imageNamed:@"warning2"] method:@"tattle"], nil];
    if (enabledApprove) {
        [self canApproveByAPI];
    } else {
        [buttons removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
        [self.tableView reloadData];
    }
    self.rightMenu.frame = CGRectMake(320, 0, 80, 568);
    [self.view addSubview:self.rightMenu];
    CGRect frame = self.tableView.frame;
    frame.size.height = [buttons count] * 80;
    self.tableView.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_player.moviePlayer prepareToPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:NSSelectorFromString(((TableItem *)[buttons objectAtIndex:indexPath.row]).method)];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"MoreButtonTableCell";
    MoreButtonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell fillCell:cell withItem:[buttons objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [buttons count];
}

#pragma mark - Class methods

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)showMore:(id)sender
{
    self.more.selected = !self.more.selected;
    UIView *view = self.leftView,
    *view2 = self.rightMenu;
    if (view.frame.origin.x == 0) {
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = view.frame;
                             frame.origin.y = 0;
                             frame.origin.x = -80;
                             view.frame = frame;
                             CGRect frame2 = view2.frame;
                             frame2.origin.y = 0;
                             frame2.origin.x = 240;
                             view2.frame = frame2;
                         }
                         completion:^(BOOL finished) {
                         }];
    } else {
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = view.frame;
                             frame.origin.y = 0;
                             frame.origin.x = 0;
                             view.frame = frame;
                             CGRect frame2 = view2.frame;
                             frame2.origin.y = 0;
                             frame2.origin.x = 320;
                             view2.frame = frame2;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
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

- (void)deny
{
    skilleeAction = SkilleeActionDeny;
    [self approveSkilleeAndExit:NO];
}

- (void)approve
{
    skilleeAction = SkilleeActionApprove;
    [self approveSkilleeAndExit:YES];
}

- (void)favorite
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postAddToFavorites:skillee.Id withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            NSLog(@"Success add to Favorites: %@", skillee.Id);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"You have added this skillee to your favorites" delegate:nil];
            [alert show];
        } else {
            NSLog(@"Failed add to Favorites: %@, error: %@", skillee.Id, requestResult.error);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        }
    }];
}

- (void)tattle
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postMarkAsTatle:skillee.Id withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            NSLog(@"Success mark as Tatle: %@", skillee.Id);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"You have added this skillee to tattles" delegate:nil];
            [alert show];
        } else {
            NSLog(@"Failed mark as Tatle: %@, error: %@", skillee.Id, requestResult.error);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        }
    }];
}

- (void)approveSkilleeAndExit:(BOOL)approve
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postApproveOrDenySkillee:skillee.Id isApproved:approve withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            NSLog(@"Success %@: %@", approve ? @"approved" : @"denied", skillee.Id);
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSString *message = [NSString stringWithFormat:@"You have %@ this skillee", approve ? @"approved" : @"denied"];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:message delegate:self];
            [alert show];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSString *message = [NSString stringWithFormat:@"You have not %@ this skillee. Please try again!", skilleeAction == SkilleeActionApprove ? @"approved" : @"denied"];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:message delegate:nil];
            [alert show];
        }
    }];
}

#pragma mark - CustomIOS7AlertViewDelegate

- (void)dismissAlert:(CustomAlertView *)alertView withButtonIndex:(NSInteger)buttonIndex
{
    [alertView close];
    
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setSkillee
{
    self.userNameLbl.text = skillee.UserName;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeStyle:NSDateFormatterNoStyle];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [format setLocale:usLocale];
    [self.userAvatarImg setImageWithURL:skillee.UserAvatarUrl];
    if ([self isVideo:[skillee.MediaUrl absoluteString]]) {
        _player = [[MPMoviePlayerViewController alloc] initWithContentURL:skillee.MediaUrl];
        _player.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [_player.view setFrame:CGRectMake(0, 0, 320, 344)];
        [_player.moviePlayer setControlStyle:MPMovieControlStyleDefault];
        _player.moviePlayer.shouldAutoplay = NO;
        [self.skilleeMediaImg addSubview:_player.view];
        [_player.moviePlayer prepareToPlay];
        _player.moviePlayer.fullscreen = YES;
    } else {
        [self.skilleeMediaImg setImageWithURL:skillee.MediaUrl];
    }
    self.skilleeTitleLbl.text = skillee.Title;
    self.skilleeCommentLbl.text = skillee.Comment;
    self.leftView.backgroundColor = skillee.Color;
}

- (BOOL)isVideo:(NSString *)url
{
    return [url hasSuffix:@"mp4"] || [url hasSuffix:@"3gp" ] || [url hasSuffix:@"mpeg"];
}

- (void)canApproveByAPI
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getCanApprove:skillee.Id withCallBack:^(RequestResult *requestReturn) {
        BOOL canApprove = NO;
        if (requestReturn.isSuccess) {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            canApprove = [((NSNumber*)requestReturn.firstObject) boolValue];
            NSLog(@"Can approve: %@", canApprove ? @"YES" : @"FALSE");
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSLog(@"Failed get can approve: %@, error: %@", skillee.Id, requestReturn.error);
        }
        if (!canApprove) {
            [buttons removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
            CGRect frame = self.tableView.frame;
            frame.size.height = [buttons count] * 80;
            self.tableView.frame = frame;
            [self.tableView reloadData];
        }
    }];
}

- (void)setCellFonts
{
    [self.userNameLbl setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    [self.skilleeTitleLbl setFont:[UIFont getDKCrayonFontWithSize:LABEL_BIG]];
    [self.skilleeCommentLbl setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    [self.back.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_SMALL]];
    [self.more.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_SMALL]];
    self.more.alpha = 0.6;
    self.back.alpha = 0.6;
    self.userAvatarImg.layer.cornerRadius = 28.0;
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvatarImg.layer.borderWidth = BORDER_WIDTH_MEDIUM;
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

@end
