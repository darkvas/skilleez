//
//  MenuViewController.m
//  skilleez
//
//  Created by Roma on 3/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeViewController.h"
#import "FriendsFamilyViewController.h"
#import "UIFont+DefaultFont.h"
#import "UserSettingsManager.h"
#import "EditProfileViewController.h"
#import "TableItem.h"
#import "MessageListViewController.h"
#import "LoginViewController.h"
#import "ColorManager.h"

@interface MenuViewController () {
    NSArray *items;
}
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logout;
@property (strong, nonatomic) HomeViewController *loopCtrl;

- (IBAction)logout:(id)sender;

@end

@implementation MenuViewController

#pragma mark - initialization

- (id)initWithController:(HomeViewController *)loop
{
    if (self = [super init]) {
        self.loopCtrl = loop;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    items = [NSArray arrayWithObjects:[[TableItem alloc] initWithName:@"My profile" image:[UIImage imageNamed:@"my_profile_icon"] method:@"showMyProfile"],
                                      [[TableItem alloc] initWithName:@"Events" image:[UIImage imageNamed:@"events_icon"] method:@"showMyProfile"],
                                      [[TableItem alloc] initWithName:@"Find friends" image:[UIImage imageNamed:@"fing_user_BTN"] method:@"findFriends"],
                                      //[[TableItem alloc] initWithName:@"My Messages" image:nil method:@"showMessages"],
                                      [[TableItem alloc] initWithName:@"Friends & Family" image:[UIImage imageNamed:@"friends_and_family_icon"] method:@"showFamily"], nil];
    [self.userAvatarImg setImageWithURL:[UserSettingsManager sharedInstance].userInfo.AvatarUrl];
    self.usernameLbl.text = [UserSettingsManager sharedInstance].userInfo.FullName;
    [self customize];
    
    [self subscribeUserInfo];
    //s Do any additional setup after loading the view.
}

-(void) subscribeUserInfo
{
    [[UserSettingsManager sharedInstance] addDelegateObserver:^{
        [self.userAvatarImg setImageWithURL:[UserSettingsManager sharedInstance].userInfo.AvatarUrl];
        self.usernameLbl.text = [UserSettingsManager sharedInstance].userInfo.FullName;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UITableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [ColorManager colorForCellBackground];
    cell.textLabel.font = [UIFont getDKCrayonFontWithSize:22.f];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [ColorManager colorForDarkBackground];
    [cell setSelectedBackgroundView:bgColorView];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = ((TableItem *)[items objectAtIndex:indexPath.row]).image;
    cell.textLabel.text = ((TableItem *)[items objectAtIndex:indexPath.row]).name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:NSSelectorFromString(((TableItem *)[items objectAtIndex:indexPath.row]).method)];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Class methods

- (void)customize
{
    [self.usernameLbl setFont:[UIFont getDKCrayonFontWithSize:28]];
    self.userAvatarImg.layer.cornerRadius = 32.f;
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvatarImg.layer.borderWidth = 3.f;
    self.tableView.frame = CGRectMake(0, 90, 256, [items count] * 50);
    self.logout.titleLabel.font = [UIFont getDKCrayonFontWithSize:22];
}

- (void)showMyProfile
{
    EditProfileViewController *profile = [EditProfileViewController new];
    [self.loopCtrl.navigationController pushViewController:profile animated:YES];
    [self.loopCtrl hideMenu];
}

- (void)showEvents
{
    
}

- (void)findFriends
{
    SearchUserViewController *search = [SearchUserViewController new];
    [self.loopCtrl.navigationController pushViewController:search animated:YES];
    [self.loopCtrl hideMenu];
}

- (void)showFamily
{
    FriendsFamilyViewController *familyCtrl = [FriendsFamilyViewController new];
    [self.loopCtrl.navigationController pushViewController:familyCtrl animated:YES];
    [self.loopCtrl hideMenu];
}

- (void)showMessages
{
    MessageListViewController *messageListView = [MessageListViewController new];
    [self.loopCtrl.navigationController pushViewController:messageListView animated:YES];
    [self.loopCtrl hideMenu];
}

- (IBAction)logout:(id)sender
{
    [[UserSettingsManager sharedInstance] deleteSettings];
    LoginViewController *login = [LoginViewController new];
    [self.loopCtrl.navigationController pushViewController:login animated:YES];
}

@end
