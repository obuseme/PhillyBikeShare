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
#import "AppDelegate.h"

#import "UIColor+HexColors.h"

#import "Constants.h"

#import "Rack.h"
#import "User.h"

#import <QuartzCore/QuartzCore.h>
#import <HealthKit/HealthKit.h>

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

@property (nonatomic, weak) IBOutlet UIButton *stationButton;
@property (nonatomic, weak) IBOutlet UIButton *bikesButton;
@property (nonatomic, weak) IBOutlet UIButton *racksButton;

@property (nonatomic, weak) IBOutlet UIView *searchContainerView;
@property (nonatomic, weak) IBOutlet UITextField *searchField;

@property (nonatomic, weak) IBOutlet UIView *rideCompleteView;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;

@property (nonatomic) NSDate *startDate;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor darkGrayColor]];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"hamburger"];

    self.searchContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchContainerView.layer.borderWidth = 1.0f;
    self.rideCompleteView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.rideCompleteView.layer.borderWidth = 1.0f;
    
    UIImageView *imgSearch=[[UIImageView alloc] initWithFrame:CGRectMake(0, -10, 20, 20)];
    [imgSearch setImage:[UIImage imageNamed:@"search.png"]];
    [imgSearch setContentMode:UIViewContentModeScaleAspectFit];
    self.searchField.leftView=imgSearch;
    self.searchField.leftViewMode=UITextFieldViewModeAlways;

    [self toggleStations:nil];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-long"]];
    [[self.stationButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.racksButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.bikesButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    
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
    [self.mapView setCamera:[GMSCameraPosition cameraWithLatitude:39.9543828 longitude:-75.1696943 zoom:13 bearing:0 viewingAngle:0]];

    [self retrieveRacks];
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
        [self addMarkersForAllStations];
    });
}

- (void)addMarkersForAllStations
{
    [self.mapView clear];
    for (Rack *rack in self.racks)
    {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([rack.lat doubleValue], [rack.lng doubleValue]);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.icon = [UIImage imageNamed:@"Icon Stations"];
        marker.map = self.mapView;
        marker.userData = rack;
    }
}

- (void)addMarkersForStationsWithBikes
{
    [self.mapView clear];
    for (Rack *rack in self.racks)
    {
        if (rack.availBikes > 0)
        {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([rack.lat doubleValue], [rack.lng doubleValue]);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.icon = [UIImage imageNamed:@"Icon Bikes"];
            marker.map = self.mapView;
            marker.userData = rack;
        }
    }
}

- (void)addMarkersForStationsWithOpenRacks
{
    [self.mapView clear];
    for (Rack *rack in self.racks)
    {
        if (([rack.maxBikes intValue] - [rack.availBikes intValue]) != 0)
        {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([rack.lat doubleValue], [rack.lng doubleValue]);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.icon = [UIImage imageNamed:@"Icon Rack"];
            marker.map = self.mapView;
            marker.userData = rack;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRoute"])
    {
        [self hideMapMarkerView];
    }
}

#pragma mark - IBActions

- (IBAction)toggleStations:(id)sender
{
    [self.stationButton setBackgroundColor:[UIColor colorWithHexString:@"0071B3"]];
    [self.bikesButton setBackgroundColor:[UIColor colorWithHexString:@"96D60B"]];
    [self.racksButton setBackgroundColor:[UIColor colorWithHexString:@"FF9001"]];
    [self addMarkersForAllStations];
}

- (IBAction)toggleBikes:(id)sender
{
    [self.stationButton setBackgroundColor:[UIColor colorWithHexString:@"0082CB"]];
    [self.bikesButton setBackgroundColor:[UIColor colorWithHexString:@"84BD00"]];
    [self.racksButton setBackgroundColor:[UIColor colorWithHexString:@"FF9001"]];
    [self addMarkersForStationsWithBikes];
}

- (IBAction)toggleRacks:(id)sender
{
    [self.stationButton setBackgroundColor:[UIColor colorWithHexString:@"0082CB"]];
    [self.bikesButton setBackgroundColor:[UIColor colorWithHexString:@"96D60B"]];
    [self.racksButton setBackgroundColor:[UIColor colorWithHexString:@"E68200"]];
    [self addMarkersForStationsWithOpenRacks];
}

- (IBAction)startStopRidePressed:(id)sender
{
    if (! self.trackingRide)
    {
        self.startStopRideButton.backgroundColor = [UIColor redColor];
        self.ridePath = [GMSMutablePath path];

        self.seconds = 0;
        self.distance = 0;
        self.locations = [NSMutableArray array];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self
                                                    selector:@selector(eachSecond) userInfo:nil repeats:YES];
        self.startDate = [NSDate date];
        self.trackingRide = YES;
        [self.startStopRideButton setTitle:@"STOP RIDE" forState:UIControlStateNormal];
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
         distance (miles)   : { type: Number, required: true },
         calories           : { type: Number, required: false }
         
         */

        self.startStopRideButton.backgroundColor = [UIColor colorWithHexString:@"0082CB"];
        self.timeLabel.text = [MathController stringifySecondCount:self.seconds usingLongFormat:NO];
        self.distanceLabel.text = [MathController stringifyDistance:self.distance];
        self.paceLabel.text = [MathController stringifyAvgPaceFromDist:self.distance overTime:self.seconds];

        self.rideCompleteView.hidden = NO;
        self.trackingRide = NO;
        [self.startStopRideButton setTitle:@"START RIDE" forState:UIControlStateNormal];
        [self.ridePath removeAllCoordinates];
        self.ridePolyline.map = nil;

        //franklin square rack id 54e88b409dcd8ff2802ca4ed
        NSString *urlString = [NSString stringWithFormat:@"%@/api/ride/new", BASE_URL];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

        User *currentUser = ((AppDelegate *)[UIApplication sharedApplication].delegate).currentUser;
        NSString * str = [NSString stringWithFormat:@"{\"userId\" : \"%@\",\"startRackId\":\"54e88b409dcd8ff2802ca4ed\",\"endRackId\":\"54e88b409dcd8ff2802ca4ee\",\"seconds\":%d,\"distance\":%d,\"startTime\":\"%@\"}", currentUser.userId, self.seconds, 2, self.startDate];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];

        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError != nil)
                                   {
                                       [[[UIAlertView alloc] initWithTitle:@"API ERROR"
                                                                   message:[connectionError description]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil] show];
                                   }
                                   else
                                   {
                                       NSError *deserializerError;
                                       [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:NSJSONReadingMutableContainers
                                                                                                   error:&deserializerError];
                                       if (deserializerError != nil)
                                       {
                                           [[[UIAlertView alloc] initWithTitle:@"JSON ERROR"
                                                                       message:[deserializerError description]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil] show];

                                       }
                                       else
                                       {

                                       }
                                   }
                               }];

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HK"])
        {
            //Save to HealthKit
            HKHealthStore *healthStore = [[HKHealthStore alloc] init];
            HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
            HKQuantity *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit meterUnit] doubleValue:2000];

            HKQuantitySample *cycleDistanceSample = [HKQuantitySample quantitySampleWithType:hkQuantityType
                                                                                    quantity:hkQuantity
                                                                                   startDate:self.startDate
                                                                                     endDate:self.startDate];

            HKQuantityType  *hkQuantityTypeCalories = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
            HKQuantity *hkQuantityCalories = [HKQuantity quantityWithUnit:[HKUnit calorieUnit] doubleValue:500];

            HKQuantitySample *calorieSample = [HKQuantitySample quantitySampleWithType:hkQuantityTypeCalories
                                                                              quantity:hkQuantityCalories
                                                                             startDate:self.startDate
                                                                               endDate:self.startDate];

            [healthStore saveObjects:@[cycleDistanceSample, calorieSample] withCompletion:^(BOOL success, NSError *error) {
                if (error)
                    NSLog(@"error saving to healthkit %@", error);
            }];
        }
    }
}

- (IBAction)closeRideCompleteView:(id)sender
{
    self.rideCompleteView.hidden = YES;
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
    [self showMapMarkerViewForRack:(Rack *)marker.userData];
    return YES;
}

- (void)dismissOverlay:(id)gesture
{
    [self hideMapMarkerView];
}

- (void)showMapMarkerViewForRack:(Rack *)rack
{
    self.mapMarkerView.nameLabel.text = rack.name;
    self.mapMarkerView.numberOfBikesLabel.text = [NSString stringWithFormat:@"%d", [rack.availBikes intValue]];
    int numberOfRackSpots = [rack.maxBikes intValue] - [rack.availBikes intValue];
    self.mapMarkerView.numberOfRacksLabel.text = [NSString stringWithFormat:@"%d", numberOfRackSpots];
    self.mapMarkerViewConstraint.constant = 0;
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideMapMarkerView
{
    self.mapMarkerViewConstraint.constant = -228;
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
        [self.mapView setCamera:[GMSCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:13 bearing:0 viewingAngle:0]];
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
