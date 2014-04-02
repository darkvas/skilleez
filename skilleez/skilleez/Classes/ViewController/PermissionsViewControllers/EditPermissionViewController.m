//
//  EditPermissionViewController.m
//  skilleez
//
//  Created by Roma on 3/31/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "EditPermissionViewController.h"
#import "UIFont+DefaultFont.h"
#import "NavigationBarView.h"
#import "EditPermissionTableCell.h"
#import "FamilyMemberCell.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"
#import "PermissionManagementViewController.h"

@interface EditPermissionViewController () {
    NSMutableArray *childs;
}
@property (weak, nonatomic) IBOutlet UILabel *permitUsernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UILabel *permitLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EditPermissionViewController

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
    [self loadFamilyData];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Edit permissions" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    [self customize];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditPermissionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditPermissionTableCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditPermissionTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell fillCell:cell withChild:[childs objectAtIndex:indexPath.row] andTag:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [childs count];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSelector:NSSelectorFromString(((TableItem *)[questions objectAtIndex:indexPath.row]).method)];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EditPermissionDelegate

- (void)editPermissions:(NSInteger)tag
{
    PermissionManagementViewController *management = [PermissionManagementViewController new];
    [self.navigationController pushViewController:management animated:YES];
}

#pragma mark - Class methods

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customize
{
    self.permitLbl.font = [UIFont getDKCrayonFontWithSize:21];
    self.accountLbl.font = [UIFont getDKCrayonFontWithSize:21];
    self.permitUsernameLbl.font = [UIFont getDKCrayonFontWithSize:21];
}
              
- (void)loadFamilyData
{
        [[NetworkManager sharedInstance] getFriendsAnsFamily:[UserSettingsManager sharedInstance].userInfo.UserID success:^(NSArray *friends) {
            for (FamilyMemberModel* member in friends) {
                childs = [NSMutableArray new];
                if(!member.IsAdult)
                    [childs addObject:member];
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"Get Friends and family error: %@", error);
        }];
    }

@end
