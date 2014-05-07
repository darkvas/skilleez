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
    FamilyMemberModel* _adultFamilyMember;
    NSMutableArray* _loopMembers;
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
        _adultFamilyMember = member;
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
    
    [self loadLoopData];
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
    [cell fillCell: cell withPermission:_permissions[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_permissions count];
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

- (void)editPermissions:(AdultPermission *)permission
{
    PermissionManagementViewController *management = [[PermissionManagementViewController alloc] initWithAdult: _adultFamilyMember
                                                                                                withPermission:permission];
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
    self.tableView.delegate = self;
    self.permitLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.accountLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.permitUsernameLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.permitUsernameLbl.text = [NSString stringWithFormat: @"Permit %@ to approve skilleez and account changes", _adultFamilyMember.FullName];
}

- (void)loadLoopData
{
    [[NetworkManager sharedInstance] getLoopById:_adultFamilyMember.Id count:100 offset:0 withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            _loopMembers = [[NSMutableArray alloc] initWithArray:requestResult.returnArray];
            [self preparePermissionsNames];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadPermissionData
{
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] getAdultPermissionsforAdultId:_adultFamilyMember.Id withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            _permissions = [[NSMutableArray alloc] initWithArray: requestResult.returnArray];
            [self preparePermissionsNames];
            [self.tableView reloadData];
        } else {
            NSLog(@"Get Adult Permissions error: %@", requestResult.error);
        }
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
    }];
}

- (void)preparePermissionsNames
{
    if(_permissions && _loopMembers) {
        for (AdultPermission *permission in _permissions) {
            if(!permission.ChildName || [permission.ChildName isEqualToString:@""])
                permission.ChildName = [self findChildNameById:permission.ChildId inLoopMembers:_loopMembers];
        }
    }
}

- (NSString *)findChildNameById:(NSString *) childId inLoopMembers: (NSArray *)loopMembers
{
    for (ProfileInfo *profile in loopMembers) {
        if ([profile.UserId isEqualToString:childId])
            return profile.ScreenName ? profile.ScreenName : profile.Login;
    }
    return childId;
}

- (void)preparePermissionsNames: (NSArray *)permissions
{
    for (AdultPermission *permission in permissions) {
        if(!permission.ChildName || [permission.ChildName isEqualToString:@""])
            [self loadProfileDataForPermission: permission];
    }
}

- (void)loadProfileDataForPermission:(AdultPermission *) permission
{
    [[NetworkManager sharedInstance] getProfileInfoByUserId:permission.ChildId withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            ProfileInfo* profile = ((ProfileInfo *)requestResult.firstObject);
            if(!profile.ScreenName || [profile.ScreenName isEqualToString:@""])
                permission.ChildName = profile.Login;
            else
                permission.ChildName = profile.ScreenName;
            [self.tableView reloadData];
        }
    }];
}

@end
