//
//  ProfileViewController.m
//  skilleez
//
//  Created by Roma on 3/25/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "EditProfileViewController.h"
#import "NavigationBarView.h"
#import "UIFont+DefaultFont.h"
#import "ProfileViewController.h"
#import "TableItem.h"
#import "UserSettingsManager.h"
#import "NetworkManager.h"
#import "ProfileInfo.h"
#import "ActivityIndicatorController.h"
#import "CustomAlertView.h"
#import "UtilityController.h"
#import "SkilleezListViewController.h"
#import "ColorManager.h"
#import "TextValidator.h"

enum {
    SPORT = 0,
    SUBJECT = 1,
    MUSIC = 2,
    FOOD = 3
} Favorite;

@interface EditProfileViewController () {
    NSArray *questions;
    float    offset;
    ProfileInfo* _profile;
    BOOL imageChanged;
    UIImagePickerController *imagePicker;
    UIColor *favoriteColor;
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
@property (weak, nonatomic) IBOutlet UILabel *myProfileLbl;

- (IBAction)editImagePressed:(id)sender;
- (IBAction)saveProfilePressed:(id)sender;

@end

@implementation EditProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self cutomize];
    [self prepareDefaultData];
    
    self.scrollView.contentSize = CGSizeMake(320, 574 + ([questions count] * 98));
    self.tableView.frame = CGRectMake(0, 549, 320, ([questions count] * 98) - 60);
    CGRect save = self.saveBtn.frame;
    save.origin.y = self.tableView.frame.origin.y + self.tableView.frame.size.height + 18;
    self.saveBtn.frame = save;
    self.scrollView.frame = self.view.frame;
    [self.view addSubview:self.scrollView];
    NavigationBarView *navBar = [[NavigationBarView alloc] initWithViewController:self withTitle:@"Profile editor" leftTitle:@"Cancel" rightButton:YES rightTitle:@"Done"];
    [self.view addSubview: navBar];
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imageChanged = NO;
    
    [self loadProfileInfo];
}

- (void)prepareDefaultData
{
    questions = [NSArray arrayWithObjects:
                 [[TableItem alloc] initWithName:@"Who am I?"
                                           image:[UIImage imageNamed:@"pandimg_BTN.png"]
                                          method:@"showProfile"],
                 [[TableItem alloc] initWithName:@"What's your favorite color?"
                                           image:favoriteColor == nil ? [self getBlankImage:[UIColor blackColor]] : [self getBlankImage:favoriteColor]
                                          method:@"chooseColor"],
                 [[TableItem alloc] initWithName:@"What's your favorite sport"
                                           image:[_profile.FavoriteSport isEqualToString:@""] || !_profile.FavoriteSport ? [UIImage imageNamed:@"sport_baseball_icon.png"] : [UIImage imageNamed:_profile.FavoriteSport]
                                          method:@"chooseSport"],
                 [[TableItem alloc] initWithName:@"What's your favorite school subject?"
                                           image:[_profile.FavoriteSchoolSubject isEqualToString:@""] || !_profile.FavoriteSchoolSubject ? [UIImage imageNamed:@"subject_art_icon.png"] : [UIImage imageNamed:_profile.FavoriteSchoolSubject]
                                          method:@"chooseSubject"],
                 [[TableItem alloc] initWithName:@"What's your favorite type of music?"
                                           image:[_profile.FavoriteTypeOfMusic isEqualToString:@""] || !_profile.FavoriteTypeOfMusic ? [UIImage imageNamed:@"music_classical_icon.png"] : [UIImage imageNamed:_profile.FavoriteTypeOfMusic]
                                          method:@"chooseMusic"],
                 [[TableItem alloc] initWithName:@"What's your favorite food?"
                                           image:[_profile.FavoriteFood isEqualToString:@""] || !_profile.FavoriteFood ? [UIImage imageNamed:@"food_blt_icon.png"] : [UIImage imageNamed:_profile.FavoriteFood]
                                          method:@"chooseFood"],
                 [[TableItem alloc] initWithName:@"My skilleez"
                                           image:[UIImage imageNamed:@"pandimg_BTN.png"]
                                          method:@"showMySkilleez"],
                 nil];
    favoriteColor = [UIColor blueColor];
}

- (void) loadProfileInfo
{
    [[NetworkManager sharedInstance] getProfileInfoByUserId:[UserSettingsManager sharedInstance].userInfo.UserID withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            _profile = (ProfileInfo *) requestResult.firstObject;
            [self updateProfileView];
        } else {
            NSLog(@"Get Profile Info error: %@", requestResult.error);
        }
    }];
}

- (void)updateProfileView
{
    [self.userAvatarImg setImageWithURL:_profile.AvatarUrl];
    self.nameTxt.text = _profile.ScreenName;
    self.loginTxt.text = _profile.Login;
    favoriteColor = _profile.Color;
    ((TableItem *)questions[1]).image = [self getBlankImage:favoriteColor];
    ((TableItem *)questions[2]).image = [_profile.FavoriteSport isEqualToString:@""] || !_profile.FavoriteSport ? [UIImage imageNamed:@"sport_baseball_icon.png"] : [UIImage imageNamed:_profile.FavoriteSport];
    ((TableItem *)questions[3]).image = [_profile.FavoriteSchoolSubject isEqualToString:@""] || !_profile.FavoriteSchoolSubject ? [UIImage imageNamed:@"subject_art_icon.png"] : [UIImage imageNamed:_profile.FavoriteSchoolSubject];
    ((TableItem *)questions[4]).image = [_profile.FavoriteTypeOfMusic isEqualToString:@""] || !_profile.FavoriteTypeOfMusic ? [UIImage imageNamed:@"music_classical_icon.png"] : [UIImage imageNamed:_profile.FavoriteTypeOfMusic];
    ((TableItem *)questions[5]).image = [_profile.FavoriteFood isEqualToString:@""] || !_profile.FavoriteFood ? [UIImage imageNamed:@"food_blt_icon.png"] : [UIImage imageNamed:_profile.FavoriteFood];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    offset = self.scrollView.contentOffset.y;
    if (offset < 196) {
        [self.scrollView setContentOffset:CGPointMake(0, 196) animated:YES];
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
        cell.backgroundColor = [ColorManager colorForCellBackground];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont getDKCrayonFontWithSize:LABEL_BIG];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [ColorManager colorForDarkBackground];
        [cell setSelectedBackgroundView:bgColorView];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = ((TableItem *)[questions objectAtIndex:indexPath.row]).name;
        return cell;
    } else {
        ProfileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        TableItem* item = (TableItem *)[questions objectAtIndex:indexPath.row];
        [cell fillCell:cell question:item.name image:item.image];
        return cell;
    }
}

- (UIImage *)getBlankImage:(UIColor *)color
{
    const int defaultSize = 100;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(defaultSize,defaultSize), NO, 0);
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,defaultSize,defaultSize)];
    [color setFill];
    [bezierPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
    [self.view endEditing:YES];
    [self performSelector:NSSelectorFromString(((TableItem *)[questions objectAtIndex:indexPath.row]).method)];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - FavoriteViewControllerDelegate

- (void)imageSelected:(NSString *)image withType:(int)type
{
    switch (type) {
        case SPORT:
            _profile.FavoriteSport = image;
            ((TableItem *)questions[2]).image = [UIImage imageNamed:image];
            break;
        case SUBJECT:
            _profile.FavoriteSchoolSubject = image;
            ((TableItem *)questions[3]).image = [UIImage imageNamed:image];
            break;
        case MUSIC:
            _profile.FavoriteTypeOfMusic = image;
            ((TableItem *)questions[4]).image = [UIImage imageNamed:image];
            break;
        default:
            _profile.FavoriteFood = image;
            ((TableItem *)questions[5]).image = [UIImage imageNamed:image];
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - ProfileViewDelegate

- (void)profileChanged:(ProfileInfo *)profile
{
    _profile = profile;
    [self updateProfileView];
}

#pragma mark - Class methods

- (void)showProfile
{
    ProfileViewController *profileView = [[ProfileViewController alloc] initWithProfile:_profile editMode:YES];
    profileView.delegate = self;
    [self.navigationController pushViewController:profileView animated:YES];
}

- (void)chooseColor
{
    ColorViewController *color = [[ColorViewController alloc] initWithProfile:_profile];
    color.delegate = self;
    [self.navigationController pushViewController:color animated:YES];
}

- (void)showMySkilleez
{
    SkilleezListViewController *skilleezView = [[SkilleezListViewController alloc] initWithUserId:[UserSettingsManager sharedInstance].userInfo.UserID andTitle:@"My Skilleez"];
    [self.navigationController pushViewController:skilleezView animated:YES];
}

- (void)chooseSport
{
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType:SPORT andProfile:_profile];
    favorite.delegate = self;
    [self.navigationController pushViewController:favorite animated:YES];
}

- (void)chooseSubject
{
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType:SUBJECT andProfile:_profile];
    favorite.delegate = self;
    [self.navigationController pushViewController:favorite animated:YES];
}

- (void)chooseMusic
{
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType:MUSIC andProfile:_profile];
    favorite.delegate = self;
    [self.navigationController pushViewController:favorite animated:YES];
}

- (void)chooseFood
{
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType:FOOD andProfile:_profile];
    favorite.delegate = self;
    [self.navigationController pushViewController:favorite animated:YES];
}

- (void)cutomize
{
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = BORDER_WIDTH_BIG;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.editAvatarBtn.layer.cornerRadius = 7.f;
    self.myProfileLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_BIG];
    self.editAvatarBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:BUTTON_MEDIUM];
    self.saveBtn.layer.cornerRadius = 7.f;
    self.saveBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:BUTTON_MEDIUM];
    self.nameLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.loginLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.passwordLbl.font = [UIFont getDKCrayonFontWithSize:LABEL_MEDIUM];
    self.nameTxt.delegate = self;
    self.loginTxt.delegate = self;
    self.passwordTxt.delegate = self;
    self.nameTxt.font = [UIFont getDKCrayonFontWithSize:LABEL_SMALL];
    self.loginTxt.font = [UIFont getDKCrayonFontWithSize:LABEL_SMALL];
    self.passwordTxt.font = [UIFont getDKCrayonFontWithSize:LABEL_SMALL];
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Private methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTxt) {
        return [TextValidator allowInputCharForText:string withRangeLength:range.length withOldLength:textField.text.length];
    } else if (textField == self.loginTxt) {
        return [TextValidator allowInputCharForAccount:string withRangeLength:range.length withOldLength:textField.text.length];
    } else if (textField == self.passwordTxt) {
        return [TextValidator allowInputCharForPassword:string withRangeLength:range.length withOldLength:textField.text.length];
    } else {
        return YES;
    }
}

- (IBAction)editImagePressed:(id)sender
{
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString*) kUTTypeImage];
    [self presentViewController:imagePicker animated:YES  completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSString* contentType = info[UIImagePickerControllerMediaType];
    if([contentType isEqualToString:@"public.image"]) {
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        [self.userAvatarImg setImage:chosenImage];
        imageChanged = YES;
    }
}

-(IBAction)saveProfilePressed:(id)sender
{
    if(imageChanged)
        [self uploadImage];
    
    _profile.ScreenName = self.nameTxt.text;
    _profile.Login = self.loginTxt.text;
    _profile.Password = self.passwordTxt.text;
    _profile.FavoriteColor = [[UtilityController sharedInstance] getStringFromColor:favoriteColor];
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postProfileInfo:_profile withCallBack:^(RequestResult *requestResult) {
        [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
        if(requestResult.isSuccess) {
            [self performSelector:@selector(updateAccountInformation) withObject:nil afterDelay:5];
            [self done];
        } else {
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:[[UtilityController sharedInstance] getErrorMessage:requestResult.error] delegate:nil];
            [alert show];
        }
    }];
}

- (void)updateAccountInformation
{
    [[NetworkManager sharedInstance] getUserInfo:^(RequestResult *requestResult) {
        if (requestResult.isSuccess){
            UserInfo* userInfo = (UserInfo*)requestResult.firstObject;
            
            [UserSettingsManager sharedInstance].IsAdmin = userInfo.IsAdmin;
            [UserSettingsManager sharedInstance].IsAdult = userInfo.IsAdult;
            [UserSettingsManager sharedInstance].IsVerified = userInfo.IsVerified;
            [UserSettingsManager sharedInstance].userInfo = userInfo;
        } else {
            NSLog(@"Error on GetUserInfo: %@", requestResult.error);
        }
    }];
}

- (void)uploadImage
{
    NSData* imageData = UIImageJPEGRepresentation(self.userAvatarImg.image, 1.0f);
    [[NetworkManager sharedInstance] postProfileImage:imageData withCallBack:^(RequestResult *requestResult) {
        if (!requestResult.isSuccess) {
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:[[UtilityController sharedInstance] getErrorMessage:requestResult.error] delegate:nil];
            [alert show];
        }
    }];
}

- (void)colorSelected:(UIColor *)color
{
    _profile.FavoriteColor = [[UtilityController sharedInstance] getStringFromColor:color];
    
    ((TableItem *)questions[1]).image = [self getBlankImage:color];
    [self.tableView reloadData];
}

@end
