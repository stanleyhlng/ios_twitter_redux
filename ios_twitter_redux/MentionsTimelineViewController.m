//
//  MentionsTimelineViewController.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "MentionsTimelineViewController.h"
#import "TweetViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetTableViewCell.h"

@interface MentionsTimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) TweetTableViewCell *prototypeCell;

- (void)callbackRefresh;
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)getMentionsTimelineWithParams:(NSMutableDictionary *)params
                              success:(void(^)(NSArray *tweets))success
                              failure:(void(^)(NSError *error))failure;
- (void)handleCompose;
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture;
- (void)handleRefresh;
- (void)handleTweetWithIndex:(NSInteger)index;
- (void)setupLongPressGestureRecognizer;
- (void)setupTableView;

@end

@implementation MentionsTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customizeRightBarButton];
        [self customizeTitleView];
        
        self.tweets = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self getMentionsTimelineWithParams:nil success:^(NSArray *tweets) {
            
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

- (void)callbackRefresh
{
    [self.refreshControl endRefreshing];
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
    label.text = @"MENTIONS";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)getMentionsTimelineWithParams:(NSMutableDictionary *)params
                              success:(void(^)(NSArray *tweets))success
                              failure:(void(^)(NSError *error))failure;
{
    NSLog(@"get mentions timeline with params: %@", params);
    
    [[TwitterClient instance] mentionsTimelineWithParams:params
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
    NSLog(@"handleCompose");
    [self.delegate composeFromMentionsTimelineView:self message:@""];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    CGPoint point = [longPressGesture locationInView:self.view];
    
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        [self.delegate longPressFromMentionsTimelineView:self message:nil];
    } else if (longPressGesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
    } else if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
    }
}

- (void)handleRefresh
{
    NSLog(@"handle refresh");
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(callbackRefresh) userInfo:nil repeats:NO];
}

- (void)handleTweetWithIndex:(NSInteger)index
{
    NSLog(@"handle tweet with index: %d", (int)index);
    TweetViewController *vc = [[TweetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupLongPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.navigationController.view addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setupTableView
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Table View Cell
    UINib *nib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"TweetTableViewCell"];
}

# pragma UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //cell.textLabel.text = @"Mentions Timeline";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

# pragma UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at index path: %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handleTweetWithIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"height for row at index path: %d", indexPath.row);
    
    if (!self.prototypeCell) {
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    }
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1;
}

# pragma helper methods

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TweetTableViewCell class]])
    {
        TweetTableViewCell *c = (TweetTableViewCell *)cell;
        
        //c.delegate = self;
        c.index = indexPath.row;
        c.tweet = self.tweets[indexPath.row];
        [c configure];
    }
}

@end
