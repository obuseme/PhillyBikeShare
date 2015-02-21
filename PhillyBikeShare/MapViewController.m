//
//  MapViewController.m
//  PhillyBikeShare
//
//  Created by Andrew Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "MapViewController.h"
#import "MathController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property BOOL centerOnUser;

//For tracking the ride
@property (weak, nonatomic) IBOutlet UIButton *startStopRideButton;
@property BOOL trackingRide;
@property int seconds;
@property float distance;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) GMSMutablePath *ridePath;
@property (nonatomic, strong) GMSPolyline *ridePolyline;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5;
    self.locationManager.activityType = CLActivityTypeFitness;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    
    self.centerOnUser = YES;
}

#pragma mark - IBActions

- (IBAction)startStopRidePressed:(id)sender
{
    if (! self.trackingRide)
    {
        self.ridePath = [GMSMutablePath path];

        self.seconds = 0;
        self.distance = 0;
        self.locations = [NSMutableArray array];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self
                                                    selector:@selector(eachSecond) userInfo:nil repeats:YES];
        self.trackingRide = YES;
        [self.startStopRideButton setTitle:@"Stop Ride" forState:UIControlStateNormal];
    }
    else
    {
        NSString *time = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:self.seconds usingLongFormat:NO]];
        NSString *distance = [NSString stringWithFormat:@"Distance: %@", [MathController stringifyDistance:self.distance]];
        NSString *pace = [NSString stringWithFormat:@"Pace: %@",  [MathController stringifyAvgPaceFromDist:self.distance overTime:self.seconds]];
        NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@", time, distance, pace];

        [[[UIAlertView alloc] initWithTitle:@"Nice Ride!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        self.trackingRide = NO;
        [self.startStopRideButton setTitle:@"Start a Ride" forState:UIControlStateNormal];
        [self.ridePath removeAllCoordinates];
        [self.mapView clear];
    }
}

#pragma mark - Tracking a Ride

- (void)eachSecond
{
    self.seconds++;
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
    if (self.trackingRide)
    {
        for (CLLocation *newLocation in locations) {
            if (newLocation.horizontalAccuracy < 20) {
                
                // update distance
                if (self.locations.count > 0) {
                    self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
                }
                
                [self.locations addObject:newLocation];
                
            }
            [self.ridePath addCoordinate:newLocation.coordinate];
            self.ridePolyline = [GMSPolyline polylineWithPath:self.ridePath];
            self.ridePolyline.map = self.mapView;

        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error updating location %@", [error description]);
}

@end
