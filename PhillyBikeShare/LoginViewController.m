//
//  LoginViewController.m
//  PhillyBikeShare
//
//  Created by Andrew Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "LoginViewController.h"
#import "PhillyBikeShare-Swift.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    RackAPIManager *manager = [RackAPIManager new];

    [manager loadAllRacks];

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
