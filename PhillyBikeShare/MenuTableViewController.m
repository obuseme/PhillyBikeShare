//
//  MenuTableViewController.m
//  PhillyBikeShare
//
//  Created by Andy Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "MenuTableViewController.h"
#import "PhillyBikeShare-Swift.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.373 green:0.373 blue:0.373 alpha:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1)
    {
        RackAPIManager *manager = [RackAPIManager new];

        [manager loadAllRacks];
    }
    if (indexPath.row == 7)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue {}

- (IBAction)unwindToLogin:(UIStoryboardSegue*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
