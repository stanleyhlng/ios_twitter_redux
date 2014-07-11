//
//  ComposeViewController.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/11/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

- (void)customizeLeftBarButton;
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)handleCancel;
- (void)handleTweet;

@end

@implementation ComposeViewController

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
    // Do any additional setup after loading the view from its nib.
    [self customizeTitleView];
    [self customizeLeftBarButton];
    [self customizeRightBarButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeLeftBarButton
{
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleCancel)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)customizeRightBarButton
{
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleTweet)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)customizeTitleView
{
    self.title = @"";
}

- (void)handleCancel
{
    NSLog(@"handle cancel");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTweet
{
    NSLog(@"handle tweet");
}

@end
