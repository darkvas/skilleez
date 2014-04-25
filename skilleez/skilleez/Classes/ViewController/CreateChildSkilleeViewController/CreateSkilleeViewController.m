//
//  CreateChildSkilleeViewController.m
//  skilleez
//
//  Created by Roma on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "CreateSkilleeViewController.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"
#import "ActivityIndicatorController.h"
#import "FamilyMemberCell.h"
#import "CustomAlertView.h"
#import "ColorManager.h"
#import "UtilityController.h"

@interface CreateSkilleeViewController (){
    UIImagePickerController *imagePicker;
    NSData* chosenData;
    enum mediaType dataMediaType;
    NSMutableArray *childs;
    NSString *selectedBehalfID;
}

@property (weak, nonatomic) IBOutlet UILabel *createSkilleeLbl;
@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
@property (weak, nonatomic) IBOutlet UITextView *commentTxt;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnAddVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectedMedia;
@property (weak, nonatomic) IBOutlet UIButton *launchBtn;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;
@property (weak, nonatomic) IBOutlet UITextField *postOnTxt;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCon;
@property (strong, nonatomic) UITableView *dropdown;
@property (strong, nonatomic) UIView *opacityLayer;

- (IBAction)launchSkillee:(id)sender;
- (IBAction)pickImage:(id)sender;
- (IBAction)pickVideo:(id)sender;
- (IBAction)titleTextViewDidChange:(id)sender;
- (IBAction)selectChild:(id)sender;

@end

@implementation CreateSkilleeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleTxt.delegate = self;
    self.commentTxt.delegate = self;
    self.postOnTxt.delegate = self;
    self.heightCon.constant = [UserSettingsManager sharedInstance].IsAdult ? 453 : 506;
    [self setDefaultFonts];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"big_text_view_BG.png"]];
    imgView.frame = CGRectMake(0, 0, 295, 128);
    [self.commentTxt addSubview: imgView];
    UILabel *placeholder = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 195, 36)];
    placeholder.textColor = [UIColor whiteColor];
    [placeholder setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    placeholder.text = @"Enter Comments here";
    [self.commentTxt addSubview:placeholder];
    [self.commentTxt sendSubviewToBack: imgView];
    [self.commentTxt sendSubviewToBack:placeholder];
    UIEdgeInsets insets = self.commentTxt.textContainerInset;
    insets.left = 6;
    self.commentTxt.textContainerInset = insets;
    [self setLeftMargin:10 forTextField:self.titleTxt];
    [self setLeftMargin:10 forTextField:self.postOnTxt];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    self.launchBtn.enabled = NO;
    if ([UserSettingsManager sharedInstance].IsAdult) {
        [self addAdultOptions];
        [self loadFamilyData:[UserSettingsManager sharedInstance].userInfo.UserID];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 13) {
        [self showDropDown];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.commentTxt.text.length == 0)
    {
        for (UIView *lbl in self.commentTxt.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)lbl;
                label.text = @"Enter Comments here";
            }
        }
    } else if(self.commentTxt.text.length > 0) {
        for (UIView *lbl in self.commentTxt.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)lbl;
                label.text = @"";
            }
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.commentTxt.text isEqualToString:@""])
    {
        for (UIView *lbl in self.commentTxt.subviews)
        {
            if ([lbl isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)lbl;
                label.text = @"Enter Comments here";
            }
        } ;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSString* contentType = info[UIImagePickerControllerMediaType];
    if([contentType isEqualToString:@"public.image"]) {
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        chosenData = UIImageJPEGRepresentation(chosenImage, 1.0f);
        dataMediaType = mediaTypeImage;
    } else if([contentType isEqualToString:@"public.movie"]){
        NSString* filePath = info[@"UIImagePickerControllerMediaURL"];
        chosenData = [[NSData alloc] initWithContentsOfFile:filePath];
        dataMediaType = mediaTypeVideo;
    }
    if(chosenData)
        self.btnSelectedMedia.hidden = NO;
    [self checkLaunchAbility];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FamilyMemberCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FamilyMemberCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [ColorManager colorForDarkBackground];
    [cell setSelectedBackgroundView:bgColorView];
    [cell setMemberData:[childs objectAtIndex:indexPath.row] andTag:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [childs count];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideDropDown:[UIGestureRecognizer new]];
    self.postOnTxt.text = ((FamilyMemberModel *)[childs objectAtIndex:indexPath.row]).FullName;
    selectedBehalfID = ((FamilyMemberModel *)[childs objectAtIndex:indexPath.row]).Id;
    [self.dropdown deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Class methods

- (void)resignAll
{
    [self.titleTxt resignFirstResponder];
    [self.commentTxt resignFirstResponder];
    [self.postOnTxt resignFirstResponder];
}

- (void)checkLaunchAbility
{
    if (chosenData && self.titleTxt.text.length > 0) {
        self.launchBtn.enabled = YES;
    } else {
        self.launchBtn.enabled = NO;
    }
}

- (IBAction)titleTextViewDidChange:(id)sender
{
    [self checkLaunchAbility];
}

- (void)setLeftMargin:(int)leftMargin forTextField:(UITextField *)textField
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftMargin, textField.frame.size.height)];
    leftView.backgroundColor = textField.backgroundColor;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setDefaultFonts
{
    [self.createSkilleeLbl setFont:[UIFont getDKCrayonFontWithSize:LABEL_BIG]];
    [self.titleTxt setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    [self.commentTxt setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    [self.postOnTxt setFont:[UIFont getDKCrayonFontWithSize:LABEL_MEDIUM]];
    [self.btnAddPhoto.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_SMALL]];
    [self.btnAddVideo.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_SMALL]];
    [self.launchBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:BUTTON_SMALL]];
    [self.termsBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:LABEL_SMALL]];
    [self.titleTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.postOnTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (IBAction)launchSkillee:(id)sender
{
    SkilleeRequest* skilleeRequest = [SkilleeRequest new];
    skilleeRequest.Title = self.titleTxt.text;
    skilleeRequest.Comment = self.commentTxt.text;
    skilleeRequest.BehalfUserId = selectedBehalfID;
    skilleeRequest.Media = chosenData;
    skilleeRequest.MediaType = dataMediaType;
    
    [[ActivityIndicatorController sharedInstance] startActivityIndicator:self];
    
    [[NetworkManager sharedInstance] postCreateSkillee:skilleeRequest withCallBack:^(RequestResult *requestResult) {
        if(requestResult.isSuccess){
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            [self clearFields];
        } else {
            [[ActivityIndicatorController sharedInstance] stopActivityIndicator];
            CustomAlertView *alert = [[CustomAlertView alloc] initDefaultOkWithText:@"Launch skillee failed" delegate:nil];
            [alert show];
        }
    }];
}

- (void)clearFields
{
    self.titleTxt.text = @"";
    self.commentTxt.text = @"";
    for (UIView *lbl in self.commentTxt.subviews)
    {
        if ([lbl isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)lbl;
            label.text = @"Enter Comments here";
        }
    }
    self.postOnTxt.text = @"";
    chosenData = nil;
    selectedBehalfID = nil;
    self.btnSelectedMedia.hidden = YES;
}

- (void)addAdultOptions
{
    self.opacityLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    self.opacityLayer .alpha = 0.0f;
    self.opacityLayer .backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.opacityLayer ];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropDown:)];
    [self.opacityLayer addGestureRecognizer:tap];
    self.dropdown = [[UITableView alloc] initWithFrame:CGRectMake(13, 99, 245, 0)];
    self.dropdown.delegate = self;
    self.dropdown.dataSource = self;
    self.dropdown.backgroundColor = [ColorManager colorForCellBackground];
    self.dropdown.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.dropdown];
}

- (IBAction)pickImage:(id)sender
{
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString*) kUTTypeImage];
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)pickVideo:(id)sender
{
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)selectChild:(id)sender
{
    [self showDropDown];
}

- (void)showDropDown
{
    [UIView animateWithDuration:0.4f animations:^{
        self.dropdown.frame =
        CGRectMake(self.dropdown.frame.origin.x,
                   self.dropdown.frame.origin.y,
                   self.dropdown.frame.size.width,
                   self.dropdown.frame.size.height + ([childs count] < 4 ? [childs count] * 55 : 170));
        self.opacityLayer.alpha = 0.25;
    }];
    [self.dropdown reloadData];
}

- (void)hideDropDown:(UIGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.4f animations:^{
        self.dropdown.frame =
        CGRectMake(self.dropdown.frame.origin.x,
                   self.dropdown.frame.origin.y,
                   self.dropdown.frame.size.width,
                   self.dropdown.frame.size.height - ([childs count] < 4 ? [childs count] * 55 : 170));
        self.opacityLayer.alpha = 0.0f;
    }];
}

- (void)loadFamilyData:(NSString *)userId
{
    [[NetworkManager sharedInstance] getFriendsAnsFamily:userId withCallBack:^(RequestResult *requestResult) {
        if (requestResult.isSuccess) {
            childs = [NSMutableArray new];
            for (FamilyMemberModel *member in requestResult.returnArray) {
                if(!member.IsAdult)
                    [childs addObject:member];
            }
        } else {
            NSLog(@"Get Friends and family error: %@", requestResult.error);
        }
    }];
}

@end
