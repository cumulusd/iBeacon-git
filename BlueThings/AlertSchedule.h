//
//  AlertSchedule.h
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface AlertSchedule : NSManagedObject

@property (nonatomic, retain) NSNumber * alertFrequencyID;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * friday;
@property (nonatomic, retain) NSNumber * locationEventTypeID;
@property (nonatomic, retain) NSNumber * monday;
@property (nonatomic, retain) NSNumber * saturday;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * sunday;
@property (nonatomic, retain) NSNumber * thursday;
@property (nonatomic, retain) NSNumber * tuesday;
@property (nonatomic, retain) NSNumber * wednesday;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) Location *alertLocation;

@end
