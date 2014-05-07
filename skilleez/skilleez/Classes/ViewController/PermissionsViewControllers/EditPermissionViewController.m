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
#import "ActivityIndicatorController.h"

const int FONT_SIZE_EP = 21;

@interface EditPermissionViewController () {
    FamilyMemberModel* _familyMember;
    NSMutableArray* _childMembers;
    NSMutableArray* _permissions;
}
@property (weak, nonatomic) IBOutlet UILabel *permitUsernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UILabel *permitLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EditPermissionViewController

- (id) initWithMemberInfo: (FamilyMemberModel*) member
{
    if (self = [super init]) {
        _familyMember = member;
    }
    return self;
}

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
    
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Edit permissions" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    [self customize];
    
    [self loadChildMembers];
    [self loadPermissionData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self loadPermissionData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditPermissionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditPermissionTableCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditPermissionTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    FamilyMemberModel* childMember = _childMembers[indexPath.row];
    [cell fillCell: cell withMember:childMember andPermission:[self getPermissionForChild: childMember]];
    cell.delegate = self;
    return cell;
}

- (AdultPermission *)getPermissionForChild:(FamilyMemberModel *)childMember
{
    for (AdultPermission *permission in _permissions) {
        if ([permission.ChildId isEqualToString:childMember.Id])
            return permission;
    }
    return [self getDefaultPermission];
}

- (AdultPermission *)getDefaultPermission
{
    AdultPermission *permission = [AdultPermission new];
    permission.ChangesApproval = YES;
    permission.LoopApproval = YES;
    permission.ProfileApproval = YES;
    return permission;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_childMembers count];
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

- (void)editPermissions:(AdultPermission *)permission forMember:(FamilyMemberModel *)childMember
{
    PermissionManagementViewController *management = [[PermissionManagementViewController alloc] initWithAdult: _familyMember withChild:childMember andPermission:permission];
    [self.navigationController pushViewController:management animated:YES];
}

#pragma mark - Class methods

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customize
{
    self.permitLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.accountLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.permitUsernameLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
}
              
- (void) loadChildMembers
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getFamilyMembers:_familyMember.Id withCallBack:^(RequestResult *requestResult) {
            if(requestResult.isSuccess) {
                _childMembers = [[NSMutableArray alloc]  init];
                for (FamilyMemberModel* member in requestResult.returnArray) {
                    if (!member.IsAdult)
                        [_childMembers addObject:member];
                }
                [self.tableView reloadData];
            } else {
                NSLog(@"Get Family Members error: %@", requestResult.error);
            }
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
    }];
}

- (void)loadPermissionData
{
    [[NetworkManager sharedInstance] getAdultPermissionsforAdultId:_familyMember.Id withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            _permissions = [[NSMutableArray alloc] initWithArray: requestResult.returnArray];
            [self.tableView reloadData];
        } else {
            NSLog(@"Get Adult Permissions error: %@", requestResult.error);
        }
    }];
}

@end
