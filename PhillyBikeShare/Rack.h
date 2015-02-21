//
//  Rack.h
//  PhillyBikeShare
//
//  Created by Mike Stanziano on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Rack : NSManagedObject

@property (nonatomic, retain) NSString * rackId;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lng;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * maxBikes;
@property (nonatomic, retain) NSNumber * availBikes;

@end
