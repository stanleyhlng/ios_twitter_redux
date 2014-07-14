//
//  HomeTimelineViewController.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "HomeTimelineViewController.h"
#import "TweetViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "TwitterClient.h"
#import "Tweet.h"

@interface HomeTimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;

- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)getHomeTimelineWithParams:(NSMutableDictionary *)params
                          success:(void(^)(NSArray *tweets))success
                          failure:(void(^)(NSError *error))failure;
- (void)handleCompose;
- (void)handleTweetWithIndex:(NSInteger)index;
- (void)setupLongPressGestureRecognizer;
- (void)setupTableView;

@end

@implementation HomeTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization]
        [self customizeRightBarButton];
        [self customizeTitleView];
        
        self.tweets = [[NSMutableArray alloc] initWithCapacity:0];

        [self getHomeTimelineWithParams:nil success:^(NSArray *tweets) {
            
            self.tweets = [tweets mutableCopy];
            NSLog(@"[INIT] tweets.count: %d / %d", tweets.count, self.tweets.count);
            
            [self.tableView reloadData];
            
        } failure:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupLongPressGestureRecognizer];
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeRightBarButton
{
    UIImage *image = [[UIImage imageNamed:@"icon-compose"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *button = [[UIButton alloc] init];

    button.frame = CGRectMake(0, 0, 30, 30);
    button.contentMode = UIViewContentModeScaleAspectFit;

    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleCompose) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)customizeTitleView;
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.text = @"TIMELINE";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)getHomeTimelineWithParams:(NSMutableDictionary *)params
                          success:(void(^)(NSArray *tweets))success
                          failure:(void(^)(NSError *error))failure;
{
    NSLog(@"get home timeline with params: %@", params);
    
    [[TwitterClient instance] homeTimelineWithParams:params
                                             success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
                                                 //NSLog(@"success: %@", tweets);
                                                 success(tweets);
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 NSLog(@"failure: %@", error);
                                                 if (failure != nil) {
                                                     failure(error);
                                                 }
                                             }];
}

- (void)handleCompose
{
    NSLog(@"handle compose");
    [self.delegate composeFromHomeTimelineView:self message:@""];
}

- (void)handleTweetWithIndex:(NSInteger)index
{
    NSLog(@"handle tweet with index: %d", index);
    TweetViewController *vc = [[TweetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    CGPoint point = [longPressGestureRecognizer locationInView:self.view];
    
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        [self.delegate longPressFromHomeTimelineView:self message:nil];
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
    }
}

- (void)setupLongPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.navigationController.view addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

# pragma UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    Tweet *tweet = self.tweets[indexPath.row];
    cell.textLabel.text = tweet.text;
    
    return cell;
}

# pragma UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at index path: %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handleTweetWithIndex:indexPath.row];
}

@end
