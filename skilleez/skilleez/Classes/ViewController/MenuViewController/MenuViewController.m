//
//  MenuViewController.m
//  skilleez
//
//  Created by Roma on 3/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "MenuViewController.h"
#import "LoopActivityViewController.h"
#import "FriendsFamilyViewController.h"
#import "UIFont+DefaultFont.h"
#import "UserSettingsManager.h"
#import "EditProfileViewController.h"
#import "TableItem.h"

@interface MenuViewController () {
    NSArray *items;
}
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LoopActivityViewController *loopCtrl;

@end

@implementation MenuViewController

#pragma mark - initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLoopController:(LoopActivityViewController *)loop
{
    if (self = [super init]) {
        self.loopCtrl = loop;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    items = [NSArray arrayWithObjects:[[TableItem alloc] initWithName:@"My profile" image:@"" method:@"showMyProfile"],
                                      [[TableItem alloc] initWithName:@"Events" image:@"" method:@"showMyProfile"],
                                      [[TableItem alloc] initWithName:@"Find friends" image:@"" method:@"showMyProfile"],
                                      [[TableItem alloc] initWithName:@"Friends & Family" image:@"" method:@"showFamily"], nil];
    [self.userAvatarImg setImageWithURL:[NSURL URLWithString:[UserSettingsManager sharedInstance].userInfo.AvatarUrl]];
    self.usernameLbl.text = [UserSettingsManager sharedInstance].userInfo.FullName;
    self.tableView.frame = CGRectMake(0, 82, 256, [items count] * 48);
    [self customize];
	// Do any additional setup after loading the view.
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
    cell.backgroundColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.f];
    cell.textLabel.font = [UIFont getDKCrayonFontWithSize:22.f];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.94 green:0.72 blue:0.12 alpha:1.f];
    [cell setSelectedBackgroundView:bgColorView];
    cell.textLabel.textColor = [UIColor whiteColor];
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
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:NSSelectorFromString(((TableItem *)[items objectAtIndex:indexPath.row]).method)];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Class methods

- (void)customize
{
    [self.usernameLbl setFont:[UIFont getDKCrayonFontWithSize:31]];
    self.userAvatarImg.layer.cornerRadius = 32.f;
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvatarImg.layer.borderWidth = 3.f;
}

- (void)showMyProfile
{
    EditProfileViewController *profile = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    [self.loopCtrl.navigationController pushViewController:profile animated:YES];
    [self.loopCtrl hideMenu];
}

- (void)showEvents
{
    
}

- (void)findFriends
{
}

- (void)showFamily
{
    FriendsFamilyViewController *familyCtrl = [[FriendsFamilyViewController alloc] initWithNibName:@"FriendsFamilyViewController" bundle:nil];
    [((UIViewController*)self.view.superview.nextResponder).navigationController pushViewController:familyCtrl animated:YES];
    [self.loopCtrl hideMenu];
}

@end
