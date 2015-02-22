//
//  AccountSettingsTableViewController.m
//  PhillyBikeShare
//
//  Created by Andy Obusek on 2/22/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "AccountSettingsTableViewController.h"
#import <HealthKit/HealthKit.h>

@interface AccountSettingsTableViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *healthKitSwitch;

@end

@implementation AccountSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"hamburger"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HK"])
    {
        self.healthKitSwitch.on = YES;
    }
}

- (IBAction)toggleHealthKitAccess:(id)sender
{
    if (self.healthKitSwitch.on)
    {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];

        // Share body mass, height and body mass index
        NSSet *shareObjectTypes = [NSSet setWithObjects:
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned],
                                   nil];

        // Read date of birth, biological sex and step count
        NSSet *readObjectTypes  = [NSSet setWithObjects:
                                   [HKObjectType characteristicTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],
                                   [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
                                   [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
                                   nil];

        // Request access
        [healthStore requestAuthorizationToShareTypes:shareObjectTypes
                                            readTypes:readObjectTypes
                                           completion:^(BOOL success, NSError *error) {

                                               if(success == YES)
                                               {
                                                   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HK"];
                                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                               }
                                               else
                                               {
                                                   [[[UIAlertView alloc] initWithTitle:@"Error" message:@"In order to use HealthKit you must grant us access" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                               }
                                               
                                           }];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HK"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
