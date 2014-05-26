//
//  BlueImperator.m
//  BlueThings
//
//  Created by Daniel Bradford on 12/8/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "BeaconGroup+Create.h"
#import "BlueImperator.h"
#import "BlueData.h"
#import "BlueAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "AlertSchedule+Create.h"
#import "Location+Create.h"
#import "BeaconGroup+Create.h"

@interface BlueImperator() <CLLocationManagerDelegate>
@property (strong,readonly,nonatomic) CLLocationManager *locationManager;
@property (strong,readonly,nonatomic) NSMutableDictionary *monitoredRegions;
@property (weak, nonatomic) BlueData *blueData;
@property (strong, nonatomic) NSMutableArray *scheduledAlerts;
@property (nonatomic, copy) void (^completionHandler)(UIBackgroundFetchResult fetchResult);

@end

@implementation BlueImperator

// **** Locals

BOOL isForeground;
int activeRegions;

// **** Properties

@synthesize locationManager = _locationManager;
@synthesize monitoredRegions = _monitoredRegions;

-(NSMutableDictionary*)monitoredRegions
{
    if(! _monitoredRegions)
    {
        _monitoredRegions = [[NSMutableDictionary alloc] init];
    }
    return _monitoredRegions;
}

-(CLLocationManager*)locationManager
{
    if(! _locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

// **** Public

-(id)init
{
    self = [super init];
    if(self)
    {
        activeRegions = 0;
        isForeground = YES;
        BlueAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.blueData = appDelegate.blueData;
        
    }
    return self;
}

-(void)startMonitoring
{
    [self fetchBeaconGroupsAndStartMonitoring];
}

-(void)didUpdateAlertSchedule
{
    self.scheduledAlerts = [NSMutableArray arrayWithArray: [self.blueData fetchAlertSchedule]];
}

-(void)didEnterForeground
{
    isForeground = YES;
    NSLog(@"app in foreground");
    //[self toggleBeaconRegionRanging:isForeground];
}

-(void)didEnterBackground
{
    isForeground = NO;
    NSLog(@"app in background");

    //[self toggleBeaconRegionRanging:isForeground];
}

-(void)didAwakeInBackgroundWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = @"awake in background";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    if(activeRegions > 0)
        self.completionHandler = completionHandler;
    else
    {
        NSLog(@"Not in any regions.");
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

// **** Private

-(void)toggleBeaconRegionRanging:(BOOL)startRanging
{
    CLBeaconRegion *beaconRegion;
    for(NSString* beaconUUID in self.monitoredRegions.allKeys)
    {
        beaconRegion = (CLBeaconRegion*)[self.monitoredRegions objectForKey:beaconUUID];
        if(startRanging)
            [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        else
            [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

-(void)fetchBeaconGroupsAndStartMonitoring
{
    BeaconGroup *beaconGrp;
    CLBeaconRegion *beaconRegion;
    NSArray *beaconGroups = [self.blueData fetchBeaconGroups];
    
    [self didUpdateAlertSchedule];
    
    for(int i = 0; i < [beaconGroups count]; i++)
    {
        beaconGrp = (BeaconGroup*)[beaconGroups objectAtIndex:i];
        if(! [self.monitoredRegions objectForKey:beaconGrp.beaconUUID])
        {
            beaconRegion = [self createBeaconRegionWithUUID:beaconGrp.beaconUUID andIdentifier:beaconGrp.name];
            [self.monitoredRegions setObject:beaconRegion forKey:beaconGrp.beaconUUID];
            [self.locationManager startMonitoringForRegion:beaconRegion];
        }
    }
    
}

-(CLBeaconRegion*)createBeaconRegionWithUUID:(NSString*)UUID andIdentifier:(NSString*)identifier
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:UUID] identifier:identifier];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    
    return beaconRegion;
}

-(void)didRangeBeacon:(CLBeacon*)beacon
{
    AlertSchedule *schedule;
    NSInteger alertFrequency;
    
    for(int i = 0; i < [self.scheduledAlerts count]; i++)
    {
        schedule = (AlertSchedule*)[self.scheduledAlerts objectAtIndex:i];
        
        if ([schedule.alertLocation.beaconGroup.beaconUUID isEqualToString:[beacon.proximityUUID UUIDString]] && [schedule.alertLocation.majorID isEqualToNumber:beacon.major] && [schedule.alertLocation.minorID isEqualToNumber:beacon.minor]) {
            alertFrequency = [schedule.alertFrequencyID integerValue];
            
            int x1 = [schedule.locationEventTypeID intValue];
            int x2 = beacon.proximity;
            
            if([schedule.locationEventTypeID integerValue] == beacon.proximity)
            {
                if (alertFrequency == AlertFrequencyAlways || alertFrequency == AlertFrequencyOnlyOnce)
                {
                    [self.scheduledAlerts removeObject:schedule];
                    [self notifyUserWithMessage:schedule.message];
                }
                else if(alertFrequency == AlertFrequencyDefinedTimesAndDaysOfWeek)
                {
                    
                }

            }
        }
    }
}

-(void)notifyUserWithMessage:(NSString*)message
{
    if(isForeground)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Alert" message:message delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else{
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = message;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

// CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString *strState;
    CLBeaconRegion *beaconRegion = (CLBeaconRegion*)region;
    if(state == CLRegionStateInside)
    {
        activeRegions += 1;
        strState = @"INSIDE";
        [manager startRangingBeaconsInRegion:beaconRegion];
    }
    else if (state == CLRegionStateOutside)
    {
        if(activeRegions > 0)
            activeRegions -= 1;
        strState = @"OUTSIDE";
        [manager stopRangingBeaconsInRegion:beaconRegion];
    }
    else if (state == CLRegionStateUnknown)
        strState = @"UNKNOWN";
    
    NSLog(@"%@ %@", strState, [beaconRegion.proximityUUID UUIDString]);
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CLBeacon *beacon;

    NSLog(@"didRangeBeacons");
    
    for(int i = 0; i < [beacons count]; i++)
    {
        beacon = (CLBeacon*)[beacons objectAtIndex:i];
        
        if(beacon.proximity != CLProximityUnknown)
        {
            [self didRangeBeacon:beacon];
        }
    }
    
    if(isForeground == NO)
    {
        NSTimeInterval timeRemaining = [UIApplication sharedApplication].backgroundTimeRemaining;
        NSLog(@"Background time remaining: %f seconds (%d mins)", timeRemaining, (int)(timeRemaining / 60));
        if(timeRemaining < 10)
            self.completionHandler(UIBackgroundFetchResultNewData);
    }
}

-(void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"ranging failed for region - %@", error);
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoring did fail for region - %@", error);
}

@end
