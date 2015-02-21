//
//  MapViewController.m
//  PhillyBikeShare
//
//  Created by Andrew Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property BOOL centerOnUser;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    
    self.centerOnUser = YES;
    
}

#pragma mark - GMSMapViewDelegate methods

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    self.centerOnUser = YES;
    //NO is for default behavior
    return NO;
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (gesture)
        self.centerOnUser = NO;
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    if (self.centerOnUser)
    {
        [self.mapView setCamera:[GMSCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:15 bearing:0 viewingAngle:0]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error updating location %@", [error description]);
}

@end
