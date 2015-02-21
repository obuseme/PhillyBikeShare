//
//  MapViewController.m
//  PhillyBikeShare
//
//  Created by Andrew Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "MapViewController.h"
#import "MathController.h"
#import "MapMarkerView.h"
#import "Rack.h"
#import "AppDelegate.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property BOOL centerOnUser;

//For tracking the ride
@property (weak, nonatomic) IBOutlet UIButton *startStopRideButton;
@property BOOL trackingRide;
@property int seconds;
@property float distance;
@property (nonatomic) NSMutableArray *locations;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) GMSMutablePath *ridePath;
@property (nonatomic) GMSPolyline *ridePolyline;

//Map Markers
@property (nonatomic, weak) IBOutlet MapMarkerView *mapMarkerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mapMarkerViewConstraint;

@property (nonatomic) NSArray *racks;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rackAPIComplete:) name:@"RacksAPIComplete" object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5;
    self.locationManager.activityType = CLActivityTypeFitness;
    [self.locationManager requestAlwaysAuthorization];
    //This code is nice, but will center map on San Fran
//    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    
    self.centerOnUser = YES;
    
    //Artificially center camera on Philly for now
    [self.mapView setCamera:[GMSCameraPosition cameraWithLatitude:39.9543828 longitude:-75.1496943 zoom:12 bearing:0 viewingAngle:0]];
    
}

- (void)rackAPIComplete:(id)notification
{
    [self retrieveRacks];
}

- (void)retrieveRacks
{
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Rack"];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Rack" inManagedObjectContext:context];
    fetchRequest.entity = entityDescription;
    NSError *error = nil;
    NSArray *rackFromCoreData = [context executeFetchRequest:fetchRequest error:&error];
    self.racks = rackFromCoreData;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addMarkersFromRacks];
    });
}

- (void)addMarkersFromRacks
{
    for (Rack *rack in self.racks)
    {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([rack.lat doubleValue], [rack.lng doubleValue]);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.map = self.mapView;
    }
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
        /*
         Create ride post request
         
         userId             : { type: String, required: true, trim: true },
         bikeId             : { type: String, required: false, trim: true },
         startRackId        : { type: String, required: true, trim: true },
         endRackId          : { type: String, required: true, trim: true },
         startTime          : { type: Date, required: true },
         endTime            : { type: Date, required: true },
         distance           : { type: Number, required: true },
         calories           : { type: Number, required: false }
         
         */
        
        NSString *time = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:self.seconds usingLongFormat:NO]];
        NSString *distance = [NSString stringWithFormat:@"Distance: %@", [MathController stringifyDistance:self.distance]];
        NSString *pace = [NSString stringWithFormat:@"Pace: %@",  [MathController stringifyAvgPaceFromDist:self.distance overTime:self.seconds]];
        NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@", time, distance, pace];

        [[[UIAlertView alloc] initWithTitle:@"Nice Ride!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        self.trackingRide = NO;
        [self.startStopRideButton setTitle:@"Start a Ride" forState:UIControlStateNormal];
        [self.ridePath removeAllCoordinates];
        self.ridePolyline.map = nil;
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
    {
        self.centerOnUser = NO;
        [self hideMapMarkerView];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOverlay:)];
    [self.mapMarkerView addGestureRecognizer:tapGestureRec];
    [self showMapMarkerView];
    return YES;
}

- (void)dismissOverlay:(id)gesture
{
    [self hideMapMarkerView];
}

- (void)showMapMarkerView
{
    self.mapMarkerViewConstraint.constant = 0;
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideMapMarkerView
{
    self.mapMarkerViewConstraint.constant = -165;
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
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
            self.ridePolyline.map = nil;
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
