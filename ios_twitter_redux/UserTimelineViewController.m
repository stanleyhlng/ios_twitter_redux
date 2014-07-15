//
//  UserTimelineViewController.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TweetViewController.h"
#import "UserTimelineViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetTableViewCell.h"
#import "User.h"

@interface UserTimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (assign, nonatomic) CGRect profileBackgroundImageFrame;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) TweetTableViewCell *prototypeCell;

- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)getUserTimelineWithParams:(NSMutableDictionary *)params
                          success:(void(^)(NSArray *tweets))success
                          failure:(void(^)(NSError *error))failure;
- (void)handleCompose;
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
- (void)handleTweetWithIndex:(NSInteger)index;
- (void)setupLongPressGestureRecognizer;
- (void)setupTableView;
- (void)setupProfileImageView;
- (void)setupProfileBackgroundImageView;
- (void)setupNameLabel;
- (void)setupScreenNameLabel;

@end

@implementation UserTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customizeRightBarButton];
        [self customizeTitleView];

        self.tweets = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupLongPressGestureRecognizer];
    [self setupTableView];
    [self setupProfileImageView];
    [self setupProfileBackgroundImageView];
    [self setupNameLabel];
    [self setupScreenNameLabel];
    
    self.profileBackgroundImageFrame = self.profileBackgroundImageView.frame;
    
    User *user = self.user;
    if (user != nil) {
        NSLog(@"user: %@", user);
        NSMutableDictionary *params = [@{@"user_id": user.id} mutableCopy];
        [self getUserTimelineWithParams:params success:^(NSArray *tweets) {
            
            self.tweets = [tweets mutableCopy];
            NSLog(@"[INIT] tweets.count: %d / %d", tweets.count, self.tweets.count);
            
            [self.tableView reloadData];
            
        } failure:nil];
    }
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
    label.text = @"USER";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)getUserTimelineWithParams:(NSMutableDictionary *)params
                          success:(void(^)(NSArray *tweets))success
                          failure:(void(^)(NSError *error))failure;
{
    NSLog(@"get user timeline with params: %@", params);
    
    [[TwitterClient instance] userTimelineWithParams:params
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
    [self.delegate composeFromUserTimelineView:self message:@""];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    CGPoint point = [longPressGestureRecognizer locationInView:self.view];
    
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        [self.delegate longPressFromUserTimelineView:self message:nil];
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
    } else if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
    }
}

- (void)handleTweetWithIndex:(NSInteger)index
{
    NSLog(@"handle tweet with index: %ld", (long)index);
    
    TweetViewController *vc = [[TweetViewController alloc] init];
    vc.tweet = self.tweets[index];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    // Table View Cell
    UINib *nib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"TweetTableViewCell"];
}

- (void)setupProfileImageView
{
    User *user = self.user;
    
    NSURL *url = user.profileImageUrl;
    UIImage *placeholder = [UIImage imageNamed:@"profile"];
    
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 5.0f;
    
    [self.profileImageView setImageWithURL:url placeholderImage:placeholder];
}

- (void)setupProfileBackgroundImageView
{
    User *user = self.user;
    
    NSURL *url = user.profileBannerUrl;
    if (url == nil) {
        url = user.profileBackgroundImageUrl;
    }
    else {
        url = [NSURL URLWithString:[url.absoluteString stringByAppendingString:@"/1500x500"]];
    }
    NSLog(@"url: %@", url.absoluteString);
    
    UIImage *placeholder = [UIImage imageNamed:@"profile"];
    
    self.profileBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.profileBackgroundImageView setImageWithURL:url placeholderImage:placeholder];
}

- (void)setupNameLabel
{
    User *user = self.user;
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.text = user.name;
    [self.nameLabel sizeToFit];
}

- (void)setupScreenNameLabel
{
    User *user = self.user;
    
    self.screenNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.screenNameLabel.text = [@"@" stringByAppendingString:user.screenName];
}

# pragma UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //cell.textLabel.text = @"User Timeline";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}


# pragma UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at index path: %ld", (long)indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handleTweetWithIndex:indexPath.row];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 220.0f)];
    return view;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 220.0f;
}


# pragma UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scroll view did scroll: %f", scrollView.contentOffset.y);
    
    CGFloat offset = scrollView.contentOffset.y;
    CGRect frame = self.headerView.frame;
    
    if (offset < 0) {
        // Adjust view proportionally
        frame.origin.y = -150 - (offset / 3);
        
        // Adjust background image view
        CGFloat scale = (self.profileBackgroundImageFrame.size.width - offset / 3) / self.profileBackgroundImageFrame.size.width;
        scale = floorf(scale * 1000) / 1000;
        NSLog(@"scale: %f", scale);

        [self.profileBackgroundImageView setTransform:CGAffineTransformMakeScale(scale, scale)];
    }
    else {
        // Scroll up as normal
        frame.origin.y = -150 - offset;
    }
    
    self.headerView.frame = frame;
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
