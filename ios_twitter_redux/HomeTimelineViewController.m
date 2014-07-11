//
//  HomeTimelineViewController.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "HomeTimelineViewController.h"

@interface HomeTimelineViewController ()

@end

@implementation HomeTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Timeline";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
