//
//  MainViewController.m
//  ios_twitter_redux
//
//  Created by Stanley Ng on 7/10/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    self.leftMenu = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSIndexPath *)initialIndexPathForLeftMenu
{
    return [NSIndexPath indexPathForRow:0 inSection:1];
}

@end
