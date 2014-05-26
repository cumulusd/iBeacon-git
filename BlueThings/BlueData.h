//
//  BlueData.h
//  BlueThings
//
//  Created by Daniel Bradford on 12/5/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"

@interface BlueData : NSObject

typedef NS_ENUM(NSInteger, AlertFrequency)
{
    AlertFrequencyOnlyOnce,
    AlertFrequencyAlways,
    AlertFrequencyDefinedTimesAndDaysOfWeek
};

@property (readonly,nonatomic) BOOL isReady;

-(id)init;
-(void)open;

-(void)createAlertScheduleWithMessage:(NSString*)message forLocation:(Location*)theLocation withProximity:(CLProximity)proximity andAlertFrequency:(AlertFrequency)frequency;

-(void)removeAlertSchedule:(AlertSchedule*)schedule;

-(NSArray*)fetchLocations;
-(NSArray*)fetchAlertSchedule;
-(NSArray*)fetchBeaconGroups;

@end
