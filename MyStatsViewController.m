//
//  MyStatsViewController.m
//  PhillyBikeShare
//
//  Created by Andy Obusek on 2/22/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "MyStatsViewController.h"

@interface MyStatsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *totalRides;
@property (nonatomic, weak) IBOutlet UILabel *totalMiles;
@property (nonatomic, weak) IBOutlet UILabel *totalBikes;
@property (nonatomic, weak) IBOutlet UILabel *dateJoined;
@property (nonatomic, weak) IBOutlet UILabel *moneySaved;
@property (nonatomic, weak) IBOutlet UILabel *emissionsSaved;
@property (nonatomic, weak) IBOutlet UILabel *caloriesBurned;
@property (nonatomic, weak) IBOutlet UILabel *averageTripLength;

@end

@implementation MyStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"hamburger"];
}

@end
