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

@interface UserTimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (assign, nonatomic) CGRect backgroundImageFrame;

- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)handleCompose;
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
- (void)handleTweetWithIndex:(NSInteger)index;
- (void)setupLongPressGestureRecognizer;
- (void)setupTableView;

@end

@implementation UserTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customizeRightBarButton];
        [self customizeTitleView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupLongPressGestureRecognizer];
    [self setupTableView];
    
    self.backgroundImageFrame = self.backgroundImageView.frame;
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
}

# pragma UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"User Timeline";
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
        CGFloat scale = (self.backgroundImageFrame.size.width - offset / 3) / self.backgroundImageFrame.size.width;
        scale = floorf(scale * 1000) / 1000;
        NSLog(@"scale: %f", scale);

        [self.backgroundImageView setTransform:CGAffineTransformMakeScale(scale, scale)];
    }
    else {
        // Scroll up as normal
        frame.origin.y = -150 - offset;
    }
    
    self.headerView.frame = frame;
}

@end
