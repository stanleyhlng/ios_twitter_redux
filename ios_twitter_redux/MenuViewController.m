//
//  MenuViewController.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "AccountViewController.h"
#import "ComposeViewController.h"
#import "MenuViewController.h"
#import "HomeTimelineViewController.h"
#import "MentionsTimelineViewController.h"
#import "UserTimelineViewController.h"
#import "UserTableViewCell.h"
#import "UIViewController+AMSlideMenu.h"
#import "AVHexColor.h"
#import "TwitterClient.h"
#import "Session.h"
#import "User.h"

@interface MenuViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;

- (void)handleCompose;
- (void)handleHomeTimeline;
- (void)handleLogout;
- (void)handleMentionsTimeline;
- (void)handleUserTimeline;
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

- (void)handleCompose
{
    NSLog(@"handle compose");
    
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];

    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)handleHomeTimeline
{
    NSLog(@"handle home timeline");
    HomeTimelineViewController *vc = [[HomeTimelineViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self openContentNavigationController:nvc];
}

- (void)handleLogout
{
    NSLog(@"handle logout");

    [[TwitterClient instance] removeAccessToken];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleMentionsTimeline
{
    NSLog(@"handle mentions timeline");
    MentionsTimelineViewController *vc = [[MentionsTimelineViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self openContentNavigationController:nvc];
}

- (void)handleUserTimeline
{
    NSLog(@"handle user timeline");
    UserTimelineViewController *vc = [[UserTimelineViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self openContentNavigationController:nvc];
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
        {
            //cell.textLabel.text = @"Section 0";
            UserTableViewCell *userTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell" forIndexPath:indexPath];
            userTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            User *user = [[Session instance] getUser];
            userTableViewCell.user = user;
            [userTableViewCell configure];
            
            cell = userTableViewCell;
        }
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
        switch (indexPath.row) {
            case 0:
                // User Timeline
                [self handleUserTimeline];
                break;
            case 1:
                // Home Timeline
                [self handleHomeTimeline];
                break;
            case 2:
                // Mentions Timeline
                [self handleMentionsTimeline];
                break;
            case 3:
                // Logout
                [self handleLogout];
                break;
            default:
                // Unknown
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
    NSLog(@"compose from home timeline view");
    [self handleCompose];
}

- (void)longPressFromHomeTimelineView:(HomeTimelineViewController *)controller message:(NSString *)message
{
    NSLog(@"long press from home timeline view");
    AccountViewController *vc = [[AccountViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

# pragma MentionsTimelineViewControllerDelegate mehtods

- (void)composeFromMentionsTimelineView:(MentionsTimelineViewController *)controller message:(NSString *)message
{
    NSLog(@"compose from mentions timeline view");
    [self handleCompose];
}

- (void)longPressFromMentionsTimelineView:(MentionsTimelineViewController *)controller message:(NSString *)message
{
    NSLog(@"long press from mentions timeline view");
    AccountViewController *vc = [[AccountViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

# pragma UserTimelineViewControllerDelegate mehtods

- (void)composeFromUserTimelineView:(UserTimelineViewController *)controller message:(NSString *)message
{
    NSLog(@"compose from user timeline view");
    [self handleCompose];
}

- (void)longPressFromUserTimelineView:(UserTimelineViewController *)controller message:(NSString *)message
{
    NSLog(@"long press from user timeline view");
    AccountViewController *vc = [[AccountViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
