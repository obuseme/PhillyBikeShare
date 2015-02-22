//
//  RouteViewController.m
//  PhillyBikeShare
//
//  Created by Andy Obusek on 2/22/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "RouteViewController.h"

@interface RouteViewController ()

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-long"]];
}

- (IBAction)done:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
