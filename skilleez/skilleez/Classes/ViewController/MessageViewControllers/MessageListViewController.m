//
//  MessageListViewController.m
//  skilleez
//
//  Created by Vasya on 4/10/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "MessageListViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "MessageCell.h"
#import "MessageViewController.h"
#import "UserSettingsManager.h"
#import "ColorManager.h"
#import "NetworkManager.h"

@interface MessageListViewController ()
{
    NSMutableArray *messages;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblMessages;

@end

@implementation MessageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"My Messages" leftTitle:@"Cancel" rightButton:YES rightTitle:@""];
    [self.view addSubview: navBar];
    [self customizeElements];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadMessages];
}

-(void) customizeElements
{
    [self.lblMessages setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* className = @"MessageCell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
    }
    
    [cell setMessageData:[messages objectAtIndex:indexPath.row] andTag:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageViewController *messageView = [[MessageViewController alloc] initWithMessage:messages[indexPath.row]];
    [self.navigationController pushViewController:messageView animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [ColorManager colorForMessageCellHeader];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done
{
}

- (void)loadMessages
{
    messages = [NSMutableArray new];
    for (FamilyMemberModel *member in [NSMutableArray arrayWithArray:[UserSettingsManager sharedInstance].friendsAndFamily]) {
        [self getProfileInfo:member];
    }
}

-(void) getProfileInfo: (FamilyMemberModel*) member
{
    [[NetworkManager sharedInstance] getProfileInfoByUserId:member.Id withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            ProfileInfo* profileInfo = (ProfileInfo*) requestResult.firstObject;
            [messages addObject:profileInfo];
            [self.tableView reloadData];
        }
    }];
}

@end
