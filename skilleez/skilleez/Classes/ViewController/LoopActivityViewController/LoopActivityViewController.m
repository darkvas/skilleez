//
//  LoopActivityViewController.m
//  Skilleez
//
//  Created by Vasya on 3/7/14.
//  Copyright (c) 2014 MobileSoft365. All rights reserved.
//

#import "LoopActivityViewController.h"
#import "SkilleezTableCell.h"
#import "Skilleez.h"

@interface LoopActivityViewController ()

@end

@implementation LoopActivityViewController
{
    NSArray *data;
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
    Skilleez *el1 = [[Skilleez alloc] initWithUsername:@"User Userovuch 1" andDate:[NSDate date]  andUserAvatar:@"http://goodfilmguide.co.uk/wp-content/uploads/2010/04/avatar12.jpg" andAttachment:@"http://www.militarymentalhealth.org/blog/wp-content/uploads/2012/03/fishing-image.jpg" andSkilleezTitle:@"Gone fishing" andSkilleezComment:@"I like nutella with mushrooms"];
    Skilleez *el2 = [[Skilleez alloc] initWithUsername:@"User Userovuch 2" andDate:[NSDate date]  andUserAvatar:@"http://goodfilmguide.co.uk/wp-content/uploads/2010/04/avatar12.jpg" andAttachment:@"http://www.militarymentalhealth.org/blog/wp-content/uploads/2012/03/fishing-image.jpg" andSkilleezTitle:@"Gone fishing" andSkilleezComment:@"I like honey with mushrooms"];
    Skilleez *el3 = [[Skilleez alloc] initWithUsername:@"User Userovuch 3" andDate:[NSDate date]  andUserAvatar:@"http://goodfilmguide.co.uk/wp-content/uploads/2010/04/avatar12.jpg" andAttachment:@"http://www.militarymentalhealth.org/blog/wp-content/uploads/2012/03/fishing-image.jpg" andSkilleezTitle:@"Gone fishing" andSkilleezComment:@"I like jam with mushrooms"];
    data = [[NSArray alloc] initWithObjects:el1, el2, el3, nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 344;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SkilleezTableCell";
    
    SkilleezTableCell *cell = (SkilleezTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SkilleezTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setSkilleezCell:cell andSkilleez:[data objectAtIndex:indexPath.row]];
   return cell;
}

@end
