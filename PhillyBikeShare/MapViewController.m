//
//  MapViewController.m
//  PhillyBikeShare
//
//  Created by Andrew Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
