//
//  LoginViewController.m
//  PhillyBikeShare
//
//  Created by Andrew Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import "LoginViewController.h"
#import "PhillyBikeShare-Swift.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "User.h"
#import "MapViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (nonatomic, weak) IBOutlet UIView *emailLabelContainerView;
@property (nonatomic, weak) IBOutlet UIView *passwordLabelContainerView;
@property (nonatomic, weak) IBOutlet UITextField *emailField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailLabelContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.emailLabelContainerView.layer.borderWidth = 1.0f;
    self.passwordLabelContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordLabelContainerView.layer.borderWidth = 1.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (IBAction)login:(id)sender
{
    NSString *loginUrlString = [NSString stringWithFormat:@"%@/api/user/email/%@", BASE_URL, self.emailField.text];
    NSURL *loginUrl = [NSURL URLWithString:loginUrlString];
    NSURLRequest *loginRequest = [NSURLRequest requestWithURL:loginUrl];
    [NSURLConnection sendAsynchronousRequest:loginRequest
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
                                   NSDictionary *userDict = [[NSJSONSerialization JSONObjectWithData:data
                                                                                            options:NSJSONReadingMutableContainers
                                                                                              error:&deserializerError] objectForKey:@"data"][0];
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
                                       User *currentUser = [[User alloc] init];
                                       currentUser.firstName = [userDict objectForKey:@"firstName"];
                                       currentUser.lastName = [userDict objectForKey:@"lastName"];
                                       currentUser.userId = [userDict objectForKey:@"_id"];
                                       currentUser.email = [userDict objectForKey:@"email"];
                                       currentUser.trips = [userDict objectForKey:@"trips"];
                                       currentUser.averageDistance = [userDict objectForKey:@"averageDistance"];
                                       ((AppDelegate *)[UIApplication sharedApplication].delegate).currentUser = currentUser;
                                       [self performSegueWithIdentifier:@"showMap" sender:nil];
                                   }
                               }
                           }];
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
