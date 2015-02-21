//
//  MapMarkerView.h
//  PhillyBikeShare
//
//  Created by Andrew Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapMarkerView : UIView

@property (nonatomic, weak) IBOutlet UILabel *numberOfBikesLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberOfRacksLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end
