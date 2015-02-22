//
//  LeaderboardTableViewController.m
//  PhillyBikeShare
//
//  Created by Andy Obusek on 2/22/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "LeaderboardTableViewController.h"

@interface LeaderboardTableViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *friendsImageView;
@property (nonatomic, weak) IBOutlet UIImageView *everyoneImageView;

@end

@implementation LeaderboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"hamburger"];
}

- (IBAction)showFriends:(id)sender
{
    self.friendsImageView.hidden = NO;
    self.everyoneImageView.hidden = YES;
}

- (IBAction)showEveryone:(id)sender
{
    self.friendsImageView.hidden = YES;
    self.everyoneImageView.hidden = NO;
}

@end
