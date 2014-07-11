//
//  MenuViewController.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "ComposeViewController.h"
#import "MenuViewController.h"
#import "HomeTimelineViewController.h"
#import "MentionsTimelineViewController.h"
#import "UserTimelineViewController.h"
#import "UserTableViewCell.h"
#import "UIViewController+AMSlideMenu.h"
#import "AVHexColor.h"

@interface MenuViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) HomeTimelineViewController *homeTimelineViewController;
@property (strong, nonatomic) MentionsTimelineViewController *mentionsTimelineViewController;
@property (strong, nonatomic) UserTimelineViewController *userTimelineViewController;

- (void)presentCompose;
- (void)setupTableView;
- (void)setupTableViewCell;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.menuItems = @[@"Profile", @"Timelines", @"Mentions", @"Logout"];
        
        self.homeTimelineViewController = [[HomeTimelineViewController alloc] initWithNibName:@"HomeTimelineViewController" bundle:nil];
        self.homeTimelineViewController.delegate = self;
        
        self.mentionsTimelineViewController = [[MentionsTimelineViewController alloc] initWithNibName:@"MentionsTimelineViewController" bundle:nil];
        self.mentionsTimelineViewController.delegate = self;

        self.userTimelineViewController = [[UserTimelineViewController alloc] initWithNibName:@"UserTimelineViewController" bundle:nil];
        self.userTimelineViewController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
    [self setupTableViewCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentCompose
{
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [AVHexColor colorWithHexString:@"333333"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupTableViewCell
{
    UINib *nib = [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"UserTableViewCell"];
}

# pragma UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = self.menuItems.count;
            break;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
 
    switch (indexPath.section) {
        case 0:
            //cell.textLabel.text = @"Section 0";
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 1:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
            cell.textLabel.text = self.menuItems[indexPath.row];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
    }
    
    return cell;
}

# pragma UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at index path: section: %d, row: %d", indexPath.section, indexPath.row);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        UINavigationController *nvc;
        
        switch (indexPath.row) {
            case 0:
                nvc = [[UINavigationController alloc] initWithRootViewController:self.userTimelineViewController];
                break;
            case 1:
                nvc = [[UINavigationController alloc] initWithRootViewController:self.homeTimelineViewController];
                break;
            case 2:
                nvc = [[UINavigationController alloc] initWithRootViewController:self.mentionsTimelineViewController];
                break;
        }
        
        if (nvc) {
            [self openContentNavigationController:nvc];
        }
        else {
            [[self mainSlideMenu] closeLeftMenu];
        }

    } else {
        [[self mainSlideMenu] closeLeftMenu];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    switch (indexPath.section) {
        case 0:
            height = 90.0f;
            break;
        case 1:
            height = 50.0f;
            break;
    }
    return height;
}

# pragma HomeTimelineViewControllerDelegate mehtods

- (void)composeFromHomeTimelineView:(HomeTimelineViewController *)controller message:(NSString *)message
{
    NSLog(@"compse from home timeline view");
    [self presentCompose];
}

# pragma MentionsTimelineViewControllerDelegate mehtods

- (void)composeFromMentionsTimelineView:(MentionsTimelineViewController *)controller message:(NSString *)message
{
    NSLog(@"compse from mentions timeline view");
    [self presentCompose];
}

# pragma UserTimelineViewControllerDelegate mehtods

- (void)composeFromUserTimelineView:(UserTimelineViewController *)controller message:(NSString *)message
{
    NSLog(@"compse from user timeline view");
    [self presentCompose];
}

@end
