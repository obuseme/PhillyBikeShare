//
//  LeaderboardTableViewController.m
//  PhillyBikeShare
//
//  Created by Andy Obusek on 2/22/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "LeaderboardTableViewController.h"

@interface LeaderboardTableViewController ()

@end

@implementation LeaderboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"hamburger"];
}

@end
