//
//  FriendsFamilyViewController.m
//  skilleez
//
//  Created by Vasya on 3/24/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "FriendsFamilyViewController.h"

@interface FriendsFamilyViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation FriendsFamilyViewController

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
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addNavigationBarButtons
{
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style: UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style: UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
    [self.navigationItem setRightBarButtonItem:barButtonDone];
    [self.navigationItem setLeftBarButtonItem:barButtonCancel];
}

-(IBAction)doneClicked:(id)sender
{
    
}

-(IBAction)cancelClicked:(id)sender
{
    
}

@end
