//
//  MyStatsViewController.m
//  PhillyBikeShare
//
//  Created by Andy Obusek on 2/22/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "MyStatsViewController.h"

@interface MyStatsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *dateJoinedDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateJoined;

@property (nonatomic, weak) IBOutlet UILabel *totalMiles;
@property (nonatomic, weak) IBOutlet UILabel *row1SubLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalRides;
@property (nonatomic, weak) IBOutlet UILabel *row2SubLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalBikes;
@property (nonatomic, weak) IBOutlet UILabel *row3SubLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageTripLength;
@property (nonatomic, weak) IBOutlet UILabel *row4SubLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneySaved;
@property (nonatomic, weak) IBOutlet UILabel *row5SubLabel;
@property (nonatomic, weak) IBOutlet UILabel *emissionsSaved;
@property (nonatomic, weak) IBOutlet UILabel *row6SubLabel;
@property (nonatomic, weak) IBOutlet UILabel *caloriesBurned;
@property (nonatomic, weak) IBOutlet UILabel *row7SubLabel;

@property (nonatomic, weak) IBOutlet UILabel *totalMilesDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalRidesDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalBikesDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *averageTripLengthDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *moneySavedDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *emissionsSavedDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *caloriesBurnedDescLabel;


@end

@implementation MyStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"hamburger"];
    [self todayTapped:nil];
}

- (IBAction)todayTapped:(id)sender
{
    self.dateJoined.text = @"MAY 5, 2015";
    self.dateJoinedDescLabel.text = @"MEMBER SINCE:";

    self.totalMiles.text = @"13 miles";
    self.totalRides.text = @"11 rides";
    self.totalBikes.text = @"5 bikes";
    self.moneySaved.text = @"$12.50 saved";
    self.emissionsSaved.text = @"12 oz/CO2";
    self.caloriesBurned.text = @"1200 calories";
    self.averageTripLength.text = @"1.1 miles";

    self.totalMilesDescLabel.text = @"Distance Cycled";
    self.totalRidesDescLabel.text = @"Rides";
    self.totalBikesDescLabel.text = @"Different Bikes";
    self.moneySavedDescLabel.text = @"Money Saved";
    self.emissionsSavedDescLabel.text = @"Emissions Saved";
    self.caloriesBurnedDescLabel.text = @"Calories Burned";
    self.averageTripLengthDescLabel.text = @"Average Trip Length";

    self.row1SubLabel.text= @"";
    self.row2SubLabel.text= @"";
    self.row3SubLabel.text= @"";
    self.row4SubLabel.text= @"";
    self.row5SubLabel.text= @"";
    self.row6SubLabel.text= @"";
    self.row7SubLabel.text= @"";
}

- (IBAction)monthTapped:(id)sender
{
    self.dateJoined.text = @"MAY 5, 2015";
    self.dateJoinedDescLabel.text = @"MEMBER SINCE:";

    self.totalMiles.text = @"55 miles";
    self.totalRides.text = @"34 rides";
    self.totalBikes.text = @"15 bikes";
    self.moneySaved.text = @"$54.00 saved";
    self.emissionsSaved.text = @"64 oz/CO2";
    self.caloriesBurned.text = @"11,000 calories";
    self.averageTripLength.text = @"1.1 miles";

    self.totalMilesDescLabel.text = @"Distance Cycled";
    self.totalRidesDescLabel.text = @"Rides";
    self.totalBikesDescLabel.text = @"Different Bikes";
    self.moneySavedDescLabel.text = @"Money Saved";
    self.emissionsSavedDescLabel.text = @"Emissions Saved";
    self.caloriesBurnedDescLabel.text = @"Calories Burned";
    self.averageTripLengthDescLabel.text = @"Average Trip Length";

    self.row1SubLabel.text= @"";
    self.row2SubLabel.text= @"";
    self.row3SubLabel.text= @"";
    self.row4SubLabel.text= @"";
    self.row5SubLabel.text= @"";
    self.row6SubLabel.text= @"";
    self.row7SubLabel.text= @"";
}

- (IBAction)badgesTapped:(id)sender
{
    self.dateJoined.text = @"15 EARNED";
    self.dateJoinedDescLabel.text = @"TOTAL BADGES:";
    
    self.totalMiles.text = @"";
    self.totalRides.text = @"";
    self.totalBikes.text = @"";
    self.moneySaved.text = @"";
    self.emissionsSaved.text = @"";
    self.caloriesBurned.text = @"";
    self.averageTripLength.text = @"";

    self.totalMilesDescLabel.text = @"Yo Adrian!";
    self.totalRidesDescLabel.text = @"World Tour";
    self.totalBikesDescLabel.text = @"Death Wish";
    self.moneySavedDescLabel.text = @"Broad St Rider";
    self.averageTripLengthDescLabel.text = @"Courteous";
    self.emissionsSavedDescLabel.text = @"Phanatic";
    self.caloriesBurnedDescLabel.text = @"Epic Rider";

    self.row1SubLabel.text= @"You rode past Rocky Balboa's home";
    self.row2SubLabel.text= @"You passed 109 nation flags Ben Franklin Parkway";
    self.row3SubLabel.text= @"You conquered the Art Museum Circle";
    self.row4SubLabel.text= @"You rode Broad St end to end";
    self.row5SubLabel.text= @"You reserved a bike with Apple Pay";
    self.row6SubLabel.text= @"You rode to a Phillies Game";
    self.row7SubLabel.text= @"You totalled 1000 miles";
}

@end
