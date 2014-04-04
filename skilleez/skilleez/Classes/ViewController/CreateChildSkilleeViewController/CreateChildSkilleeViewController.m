//
//  CreateChildSkilleeViewController.m
//  skilleez
//
//  Created by Roma on 3/18/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "CreateChildSkilleeViewController.h"
#import "UIFont+DefaultFont.h"
#import "NetworkManager.h"
#import "UserSettingsManager.h"

@interface CreateChildSkilleeViewController (){
    UIImagePickerController *imagePicker;
    NSData* chosenData;
    enum mediaType dataMediaType;
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

- (IBAction)launchSkillee:(id)sender;
- (IBAction)pickImage:(id)sender;
- (IBAction)pickVideo:(id)sender;
- (IBAction)titleTextViewDidChange:(id)sender;

@end

@implementation CreateChildSkilleeViewController

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
    self.titleTxt.delegate = self;
    self.commentTxt.delegate = self;
    self.heightCon.constant = [UserSettingsManager sharedInstance].IsAdult ? 453 : 506;
    [self setDefaultFonts];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"big_text_view_BG.png"]];
    imgView.frame = CGRectMake(0, 0, 295, 128);
    [self.commentTxt addSubview: imgView];
    UILabel *placeholder = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 195, 36)];
    //placeholder.textColor = [UIColor colorWithRed:0.09 green:0.09 blue:0.12 alpha:1.0];
    placeholder.textColor = [UIColor whiteColor];
    [placeholder setFont:[UIFont getDKCrayonFontWithSize:22]];
    placeholder.text = @"Enter Comments here";
    [self.commentTxt addSubview:placeholder];
    [self.commentTxt sendSubviewToBack: imgView];
    [self.commentTxt sendSubviewToBack:placeholder];
    [self setLeftMargin:10 forTextField:self.titleTxt];
    [self setLeftMargin:10 forTextField:self.postOnTxt];
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    self.launchBtn.enabled = NO;
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

- (void)resignAll
{
    [self.titleTxt resignFirstResponder];
    [self.commentTxt resignFirstResponder];
    [self.postOnTxt resignFirstResponder];
}

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

- (void)setLeftMargin:(int)leftMargin forTextField:(UITextField *)textField
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftMargin, textField.frame.size.height)];
    leftView.backgroundColor = textField.backgroundColor;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setDefaultFonts
{
    [self.createSkilleeLbl setFont:[UIFont getDKCrayonFontWithSize:31]];
    [self.titleTxt setFont:[UIFont getDKCrayonFontWithSize:22]];
    [self.commentTxt setFont:[UIFont getDKCrayonFontWithSize:22]];
    [self.postOnTxt setFont:[UIFont getDKCrayonFontWithSize:22]];
    [self.btnAddPhoto.titleLabel setFont:[UIFont getDKCrayonFontWithSize:22]];
    [self.btnAddVideo.titleLabel setFont:[UIFont getDKCrayonFontWithSize:22]];
    [self.launchBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:31]];
    [self.termsBtn.titleLabel setFont:[UIFont getDKCrayonFontWithSize:16]];
    [self.titleTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.postOnTxt setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (IBAction)launchSkillee:(id)sender {
    SkilleeRequest* skilleeRequest = [SkilleeRequest new];
    skilleeRequest.Title = self.titleTxt.text;
    skilleeRequest.Comment = self.commentTxt.text;
    skilleeRequest.BehalfUserId = self.postOnTxt.text;
    skilleeRequest.Media = chosenData;
    skilleeRequest.MediaType = dataMediaType;
    
    UIActivityIndicatorView *activityIndicator = [self getLoaderIndicator];
    
    [[NetworkManager sharedInstance] postCreateSkillee:skilleeRequest success:^{
        [activityIndicator stopAnimating];
        [self clearFields];
    } failure:^(NSError *error) {
        [activityIndicator stopAnimating];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Launch failed" message:@"Launch skillee failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }];
}

- (UIActivityIndicatorView *)getLoaderIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setBackgroundColor:[UIColor whiteColor]];
    [activityIndicator setAlpha:0.7];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    return activityIndicator;
}

- (void)clearFields
{
    self.titleTxt.text = @"";
    self.commentTxt.text = @"";
    self.postOnTxt.text = @"";
    chosenData = nil;
    self.btnSelectedMedia.hidden = YES;
}

- (IBAction)pickImage:(id)sender {
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString*) kUTTypeImage];
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)pickVideo:(id)sender {
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    [self presentModalViewController:imagePicker animated:YES];
}
@end
