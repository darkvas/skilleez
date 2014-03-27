//
//  ProfileViewController.m
//  skilleez
//
//  Created by Roma on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AppDelegate.h"
#import "UIFont+DefaultFont.h"
#import "ProfileViewController.h"

@interface EditProfileViewController () {
    NSArray *questions;
    float    offset;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImg;
@property (weak, nonatomic) IBOutlet UIButton *editAvatarBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *loginLbl;
@property (weak, nonatomic) IBOutlet UILabel *passwordLbl;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *loginTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation EditProfileViewController

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
    [self cutomize];
    /*UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:tapGesture];*/
    questions = [NSArray arrayWithObjects:@"Who am I", @"What's your favorite sport?", @"What's your favorite color", @"What's your favorite school subject?", @"My skilleez", nil];
    self.scrollView.contentSize = CGSizeMake(320, 530 + ([questions count] * 98));
    self.tableView.frame = CGRectMake(0, 505, 320, ([questions count] * 98) - 60);
    CGRect save = self.saveBtn.frame;
    save.origin.y = self.tableView.frame.origin.y + self.tableView.frame.size.height + 18;
    self.saveBtn.frame = save;
    self.scrollView.frame = self.view.frame;
    [self.view addSubview:self.scrollView];
    [[AppDelegate alloc] cutomizeNavigationBar:self withTitle:@"Profile editor" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    offset = self.scrollView.contentOffset.y;
    if (offset < 152) {
        [self.scrollView setContentOffset:CGPointMake(0, 152) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == ([questions count] - 1)) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UITableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont getDKCrayonFontWithSize:31.f];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.94 green:0.72 blue:0.12 alpha:1.f];
        [cell setSelectedBackgroundView:bgColorView];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = [questions objectAtIndex:indexPath.row];
        return cell;
    } else {
        ProfileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell fillCell:cell question:[questions objectAtIndex:indexPath.row] image:[UIImage imageNamed:@"pandimg_BTN.png"]];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [questions count];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == ([questions count] - 1)) {
        return 68;
    } else {
        return 98;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == ([questions count] - 1)) {
        ProfileViewController *profile = [[ProfileViewController alloc] init];
        [self.navigationController pushViewController:profile animated:YES];
    } else {
        
    }
}

#pragma mark - Class methods

- (void)show
{
    [self.scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
}

- (IBAction)handleGesture:(id)sender {
    [self.scrollView endEditing:YES];
}

- (void)cutomize
{
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = 5.f;
    self.userAvatarImg.layer.cornerRadius = 98.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.editAvatarBtn.layer.cornerRadius = 7.f;
    self.editAvatarBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:24.f];
    self.saveBtn.layer.cornerRadius = 7.f;
    self.saveBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:24.f];
    self.nameLbl.font = [UIFont getDKCrayonFontWithSize:21.f];
    self.loginLbl.font = [UIFont getDKCrayonFontWithSize:21.f];
    self.passwordLbl.font = [UIFont getDKCrayonFontWithSize:21.f];
    self.nameTxt.delegate = self;
    self.loginTxt.delegate = self;
    self.passwordTxt.delegate = self;
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = YES;
}

@end