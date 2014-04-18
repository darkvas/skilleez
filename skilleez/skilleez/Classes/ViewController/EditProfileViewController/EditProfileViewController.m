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
#import "SkilleezListViewController.h"

enum {
    SPORT = 0,
    SUBJECT = 1,
    MUSIC = 2,
    FOOD = 3
} Favorite;

@interface EditProfileViewController () {
    NSArray *questions;
    float    offset;
    ProfileInfo* profile;
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
@property (strong, nonatomic) NSString *sportImageName;
@property (strong, nonatomic) NSString *subjectImageName;
@property (strong, nonatomic) NSString *musicImageName;
@property (strong, nonatomic) NSString *foodImageName;

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
                                           image:self.sportImageName == nil ? [UIImage imageNamed:@"sport_baseball_icon.png"] : [UIImage imageNamed:self.sportImageName]
                                          method:@"chooseSport"],
                 [[TableItem alloc] initWithName:@"What's your favorite school subject?"
                                           image:self.subjectImageName == nil ? [UIImage imageNamed:@"subject_art_icon.png"] : [UIImage imageNamed:self.subjectImageName]
                                          method:@"chooseSubject"],
                 [[TableItem alloc] initWithName:@"What's your favorite type of music?"
                                           image:self.musicImageName == nil ? [UIImage imageNamed:@"music_classical_icon.png"] : [UIImage imageNamed:self.musicImageName]
                                          method:@"chooseMusic"],
                 [[TableItem alloc] initWithName:@"What's your favorite food?"
                                           image:self.foodImageName == nil ? [UIImage imageNamed:@"food_blt_icon.png"] : [UIImage imageNamed:self.foodImageName]
                                          method:@"chooseFood"],
                 [[TableItem alloc] initWithName:@"My skilleez"
                                           image:[UIImage imageNamed:@"pandimg_BTN.png"]
                                          method:@"showMySkilleez"],
                 nil];
    favoriteColor = [UIColor blueColor];
}

- (void) loadProfileInfo
{
    [[NetworkManager sharedInstance] getProfileInfo:[UserSettingsManager sharedInstance].userInfo.UserID withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            profile = (ProfileInfo *) requestResult.firstObject;
            [self updateProfileView];
        } else {
            NSLog(@"Get Profile Info error: %@", requestResult.error);
        }
    }];
}

- (void)updateProfileView
{
    [self.userAvatarImg setImageWithURL: profile.AvatarUrl];
    self.nameTxt.text = profile.ScreenName;
    self.loginTxt.text = profile.Login;
    self.subjectImageName = profile.FavoriteSchoolSubject;
    self.sportImageName = profile.FavoriteSport;
    self.musicImageName = profile.FavoriteTypeOfMusic;
    self.foodImageName = profile.FavoriteFood;
    favoriteColor = profile.Color;
    ((TableItem *)questions[1]).image = [self getBlankImage:favoriteColor];
    ((TableItem *)questions[2]).image = self.sportImageName == nil ? [UIImage imageNamed:@"sport_baseball_icon.png"] : [UIImage imageNamed:self.sportImageName];
    ((TableItem *)questions[3]).image = self.subjectImageName == nil ? [UIImage imageNamed:@"subject_art_icon.png"] : [UIImage imageNamed:self.subjectImageName];
    ((TableItem *)questions[4]).image = self.musicImageName == nil ? [UIImage imageNamed:@"music_classical_icon.png"] : [UIImage imageNamed:self.musicImageName];
    ((TableItem *)questions[5]).image = self.foodImageName == nil ? [UIImage imageNamed:@"food_blt_icon.png"] : [UIImage imageNamed:self.foodImageName];
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
        cell.backgroundColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont getDKCrayonFontWithSize:31.f];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:0.94 green:0.72 blue:0.12 alpha:1.f];
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
    [self performSelector:NSSelectorFromString(((TableItem *)[questions objectAtIndex:indexPath.row]).method)];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - FavoriteViewControllerDelegate

- (void)imageSelected:(NSString *)image withType:(int)type
{
    switch (type) {
        case SPORT:
            self.sportImageName = image;
            ((TableItem *)questions[2]).image = [UIImage imageNamed:image];
            break;
        case SUBJECT:
            self.subjectImageName = image;
            ((TableItem *)questions[3]).image = [UIImage imageNamed:image];
            break;
        case MUSIC:
            self.musicImageName = image;
            ((TableItem *)questions[4]).image = [UIImage imageNamed:image];
            break;
        default:
            self.foodImageName = image;
            ((TableItem *)questions[5]).image = [UIImage imageNamed:image];
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - Class methods

- (void)showProfile
{
    ProfileViewController *profileView = [[ProfileViewController alloc] initWithProfile:profile editMode:YES];
    [self.navigationController pushViewController:profileView animated:YES];
}

- (void)chooseColor
{
    ColorViewController *color = [[ColorViewController alloc] init];
    color.delegate = self;
    color.selectedColor = favoriteColor;
    [self.navigationController pushViewController:color animated:YES];
}

- (void)showMySkilleez
{
    SkilleezListViewController *skilleezView = [[SkilleezListViewController alloc] initWithUserId:[UserSettingsManager sharedInstance].userInfo.UserID andTitle:@"My Skilleez"];
    [self.navigationController pushViewController:skilleezView animated:YES];
}

- (void)chooseSport
{
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType:SPORT];
    favorite.delegate = self;
    favorite.selectedImage = self.sportImageName;
    [self.navigationController pushViewController:favorite animated:YES];
}

- (void)chooseSubject
{
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType:SUBJECT];
    favorite.delegate = self;
    favorite.selectedImage = self.subjectImageName;
    [self.navigationController pushViewController:favorite animated:YES];
}

- (void)chooseMusic
{
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType:MUSIC];
    favorite.delegate = self;
    favorite.selectedImage = self.musicImageName;
    [self.navigationController pushViewController:favorite animated:YES];
}

- (void)chooseFood
{
    SelectFavoriteViewController *favorite = [[SelectFavoriteViewController alloc] initWithType:FOOD];
    favorite.delegate = self;
    favorite.selectedImage = self.foodImageName;
    [self.navigationController pushViewController:favorite animated:YES];
}

- (void)cutomize
{
    self.userAvatarImg.layer.masksToBounds = YES;
    self.userAvatarImg.layer.borderWidth = 5.f;
    self.userAvatarImg.layer.cornerRadius = 82.f;
    self.userAvatarImg.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.editAvatarBtn.layer.cornerRadius = 7.f;
    self.myProfileLbl.font = [UIFont getDKCrayonFontWithSize:31.f];
    self.editAvatarBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:24.f];
    self.saveBtn.layer.cornerRadius = 7.f;
    self.saveBtn.titleLabel.font = [UIFont getDKCrayonFontWithSize:24.f];
    self.nameLbl.font = [UIFont getDKCrayonFontWithSize:21.f];
    self.loginLbl.font = [UIFont getDKCrayonFontWithSize:21.f];
    self.passwordLbl.font = [UIFont getDKCrayonFontWithSize:21.f];
    self.nameTxt.delegate = self;
    self.loginTxt.delegate = self;
    self.passwordTxt.delegate = self;
    self.nameTxt.font = [UIFont getDKCrayonFontWithSize:18];
    self.loginTxt.font = [UIFont getDKCrayonFontWithSize:18];
    self.passwordTxt.font = [UIFont getDKCrayonFontWithSize:18];
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
    
    profile.ScreenName = self.nameTxt.text;
    profile.Login = self.loginTxt.text;
    profile.Password = self.passwordTxt.text;
    profile.FavoriteColor = [self getStringFromColor:favoriteColor];
    profile.FavoriteSchoolSubject = self.subjectImageName;
    profile.FavoriteSport = self.sportImageName;
    profile.FavoriteTypeOfMusic = self.musicImageName;
    profile.FavoriteFood = self.foodImageName;
    
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    [[NetworkManager sharedInstance] postProfileInfo:profile withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess) {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            [self done];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            NSString* message = requestResult.error.userInfo[NSLocalizedDescriptionKey];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Load image failed" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
}

- (void)uploadImage
{
    NSData* imageData = UIImageJPEGRepresentation(self.userAvatarImg.image, 1.0f);
    [[NetworkManager sharedInstance] postProfileImage:imageData withCallBack:^(RequestResult *requestResult) {
        if (! requestResult.isSuccess) {
            NSString* message = requestResult.error.userInfo[NSLocalizedDescriptionKey];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Load image failed" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
}

- (NSString *)getStringFromColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

- (void)colorSelected:(UIColor *)color
{
    favoriteColor = color;
    //int rgbValue = [color intValue];
    //NSLog(@" - - - Profile color: %i", rgbValue);
    
    ((TableItem *)questions[1]).image = [self getBlankImage:favoriteColor];
    [self.tableView reloadData];
}

@end
