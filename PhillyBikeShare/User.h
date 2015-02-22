//
//  User.h
//  PhillyBikeShare
//
//  Created by Andrew Obusek on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSNumber *trips;
@property (nonatomic) NSNumber *averageDistance;

@end
