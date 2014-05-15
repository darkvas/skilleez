//
//  LoopActivityViewController.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "HomeViewController.h"
#import "ColorManager.h"

@interface HomeViewController ()
{
    NSTimer *timerUpdateBadge;
    BOOL _showMenu;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *topSkilleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *approvalSkilleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteSkilleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *createSkilleeBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) MenuViewController *menuCtrl;
@property (strong, nonatomic) UIButton *transparentBtn;
@property (atomic) int _invitationsCount;
@property (atomic) int _approvalCount;

- (IBAction)showMenu:(id)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    LoopViewController *loop = [[LoopViewController alloc] initWithParent:self];
    [self loadAnotherViewController:loop];
    [super viewDidLoad];
    [self.view setExclusiveTouch:YES];
    self.createViewCtrl = [CreateSkilleeViewController new];
    _showMenu = YES;
    self.menuCtrl = [[MenuViewController alloc] initWithController:self];
    self.menuCtrl.view.hidden = YES;
    self.menuCtrl.view.frame = CGRectMake(-320, 0, 320, 568);
    self.transparentBtn = [[UIButton alloc] initWithFrame:CGRectMake(256, 20, 64, 548)];
    [self.transparentBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.transparentBtn.hidden = YES;
    [self.view addSubview:self.transparentBtn];
    [self.view addSubview:self.menuCtrl.view];
    [self createBadge];
    [[UtilityController sharedInstance] setBadgeValue:0 forController:self];
    [self highlightSelectedButton:10];
    [self loadCounts];
    // Do any additional setup after loading the view from its nib.
    
    [self startTimer];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self stopTimer];
}

- (IBAction)startTimer
{
    timerUpdateBadge = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(loadCounts) userInfo:nil repeats:YES];
    [timerUpdateBadge fire];
}

- (IBAction)stopTimer
{
    [timerUpdateBadge invalidate];
}

- (void)loadCounts
{
    if ([UserSettingsManager sharedInstance].IsAdult)
        [self loadWaiingForApprovalCount];
    else
        [self loadWaitingForApprovalSkilleeCount];
}

- (void)loadWaitingForApprovalSkilleeCount
{
    [[NetworkManager sharedInstance] getWaitingForApprovalSkilleeCount:^(RequestResult *requestReturn) {
        if (requestReturn.isSuccess) {
            self._approvalCount = [((NSNumber*)requestReturn.firstObject) intValue];
            NSLog(@"Waiting from approval count %i", self._approvalCount);
        } else {
            self._approvalCount = 0;
            NSLog(@"Waiting from approval error: %@", requestReturn.error);
        }
        [[UtilityController sharedInstance] setBadgeValue:(self._approvalCount + self._invitationsCount) forController:self];
    }];
}

- (void)loadWaiingForApprovalCount
{
    [[NetworkManager sharedInstance] getWaitingForApprovalCount:^(RequestResult *requestReturn) {
        int approvalCount = 0;
        if (requestReturn.isSuccess) {
            approvalCount = [((NSNumber*)requestReturn.firstObject) intValue];
            NSLog(@"Waiting from approval count %i", approvalCount);
        } else {
            NSLog(@"Waiting from approval error: %@", requestReturn.error);
        }
        [[UtilityController sharedInstance] setBadgeValue:approvalCount forController:self];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.currentViewController != nil)
        [self.currentViewController viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class methods

- (void)loadAnotherViewController:(UIViewController *)viewController
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [self addChildViewController:viewController];
    viewController.view.hidden = YES;
    [self.contentView addSubview: viewController.view];
}

- (IBAction)loadItems:(id)sender
{
    [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    switch (((UIButton *)sender).tag) {
        case 11:
            if ([UserSettingsManager sharedInstance].userInfo.IsAdult) {
                AdultApprovalViewController *adult = [[AdultApprovalViewController alloc] initWithParent:self];
                [self loadAnotherViewController:adult];
            } else {
                ChildApprovalViewController *child = [[ChildApprovalViewController alloc] initWithParent:self];
                [self loadAnotherViewController:child];
            }
            break;
        case 12:
        {
            FavoriteViewController *favorite = [[FavoriteViewController alloc] initWithParent:self];
            [self loadAnotherViewController:favorite];
            break;
        }
        default:
        {
            LoopViewController *loop = [[LoopViewController alloc] initWithParent:self];
            [self loadAnotherViewController:loop];
            break;
        }
    }
    [self loadCounts];
    [self highlightSelectedButton:(int)((UIButton *)sender).tag];
}

#pragma mark - Class UI methods

- (IBAction)createSkillee:(id)sender
{
    self.createViewCtrl = [CreateSkilleeViewController new];
    [self.contentView addSubview:self.createViewCtrl.view];
    [self addChildViewController:self.createViewCtrl];
    [self.currentViewController removeFromParentViewController];
    [self.currentViewController.view removeFromSuperview];
    self.currentViewController = self.createViewCtrl;
    [self highlightSelectedButton:(int)((UIButton *)sender).tag];
}

- (IBAction)showMenu:(id)sender
{
    [self showMenu];
}

- (void)createBadge
{
    self.badge = [[UILabel alloc] initWithFrame:CGRectMake(32, 24, 18, 18)];
    self.badge.layer.masksToBounds = YES;
    self.badge.layer.cornerRadius = 9;
    self.badge.textAlignment = NSTextAlignmentCenter;
    self.badge.adjustsFontSizeToFitWidth = YES;
    self.badge.font = [UIFont systemFontOfSize:12];
    self.badge.minimumScaleFactor = 7 / 12;
    self.badge.textColor = [UIColor whiteColor];
    self.badge.backgroundColor = [ColorManager colorForBadgeBackground];
    [self.approvalSkilleeBtn addSubview:self.badge];
}

- (void)hideMenu
{
    self.menuCtrl.view.frame = CGRectMake(-320, 0, 320, 568);
    self.transparentBtn.hidden = YES;
    self.menuBtn.selected = !self.menuBtn.selected;
}

- (void)showMenu
{
    if (_showMenu) {
        _showMenu = NO;
        [self.createViewCtrl resignAll];
        UIView* view = self.menuCtrl.view;
        if (view.frame.origin.x == -64) {
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.transparentBtn.hidden = YES;
                                 CGRect frame = view.frame;
                                 frame.origin.y = 0;
                                 frame.origin.x = -320;
                                 view.frame = frame;
                             }
                             completion:^(BOOL finished) {
                                 _showMenu = YES;
             }];
        } else {
            view.hidden = NO;
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.transparentBtn.hidden = NO;
                                 CGRect frame = view.frame;
                                 frame.origin.y = 0;
                                 frame.origin.x = -64;
                                 view.frame = frame;
                             }
                             completion:^(BOOL finished) {
                                 _showMenu = YES;
             }];
        }
        self.menuBtn.selected = !self.menuBtn.selected;
    }
}

- (void)highlightSelectedButton:(int)button
{
    [self deselectAll];
    switch (button) {
        case 10:
            self.topSkilleeBtn.selected = YES;
            break;
        case 11:
            self.approvalSkilleeBtn.selected = YES;
            break;
        case 12:
            self.favoriteSkilleeBtn.selected = YES;
            break;
        case 13:
            self.createSkilleeBtn.selected = YES;
            break;
        default:
            self.menuBtn.selected = !self.menuBtn.selected;
            break;
    }
}

- (void)deselectAll
{
    self.topSkilleeBtn.selected = NO;
    self.favoriteSkilleeBtn.selected = NO;
    self.approvalSkilleeBtn.selected = NO;
    self.createSkilleeBtn.selected = NO;
    self.menuBtn.selected = NO;
}

@end
