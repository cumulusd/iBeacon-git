//
//  BlueData.m
//  BlueThings
//
//  Created by Daniel Bradford on 12/5/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "BlueData.h"
#import "BeaconGroup+Create.h"
#import "Location+Create.h"
#import "AlertSchedule+Create.h"
#import <CoreData/CoreData.h>

#define BlueDataName @"blueData"

@interface BlueData()
@property (strong,nonatomic) UIManagedDocument *blueData;
@property (strong,readonly,nonatomic) NSURL *blueDataPhysicalFileURL;
@property (nonatomic) BOOL isReady;
@end

@implementation BlueData

@synthesize  blueDataPhysicalFileURL = _blueDataPhysicalFileURL;
@synthesize blueData = _blueData;


-(void)setBlueData:(UIManagedDocument *)blueData
{
    if(_blueData != blueData)
    {
        _blueData = blueData;
        _blueData.persistentStoreOptions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:[self.blueData.fileURL path]])
        {
            [self.blueData saveToURL:self.blueData.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                if(success)
                {
                    [self loadDefaults];
                    self.isReady = YES;
                }
            }];
        }
        else if(self.blueData.documentState == UIDocumentStateClosed)
        {
            [self.blueData openWithCompletionHandler:^(BOOL success){
                if(success){
                    self.isReady = YES;
                }
            }];
        }
        else if(self.blueData.documentState == UIDocumentStateNormal)
        {
            self.isReady = YES;
        }

    }
}

-(NSURL*)blueDataPhysicalFileURL
{
    if(! _blueDataPhysicalFileURL)
    {
        _blueDataPhysicalFileURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        _blueDataPhysicalFileURL = [_blueDataPhysicalFileURL URLByAppendingPathComponent:BlueDataName];

    }
    return _blueDataPhysicalFileURL;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        
        
    }
    return self;
}

-(void)open
{
    if(! self.blueData)
    {
        self.blueData = [[UIManagedDocument alloc] initWithFileURL:self.blueDataPhysicalFileURL];
    }
}

-(void)loadDefaults
{
    // original uuid i was using; 820E3F14-ED6C-4390-9EDF-FF8EEAE10EB3
    // estimote uuid = B9407F30-F5F8-466E-AFF9-25556B57FE6D
    
    BeaconGroup *defaultBeaconGroup = [BeaconGroup createLocationWithUUID:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D" withName:@"Daniel's Beacons" inManagedObjectContext:self.blueData.managedObjectContext];
    [defaultBeaconGroup addLocationsObject:[Location createLocationWithName:@"Room" withMajor:57618 andMinor:59024 inManagedObjectContext:self.blueData.managedObjectContext]];
    //[defaultBeaconGroup addLocationsObject:[Location createLocationWithName:@"Office" withMajor:2 andMinor:1 inManagedObjectContext:self.blueData.managedObjectContext]];
    [self.blueData.managedObjectContext save:nil];
}

-(void)createAlertScheduleWithMessage:(NSString*)message forLocation:(Location*)theLocation withProximity:(CLProximity)proximity andAlertFrequency:(AlertFrequency)frequency
{
    [AlertSchedule createAlertScheduleWithMessage:message forLocation:theLocation withProximity:proximity andAlertFrequency:frequency inManagedObjectContext:self.blueData.managedObjectContext];
    [self.blueData.managedObjectContext save:nil];

}

-(void)removeAlertSchedule:(AlertSchedule*)schedule
{
    [self.blueData.managedObjectContext deleteObject:schedule];
}

-(NSArray*)fetchAlertSchedule
{
    NSArray* results;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AlertSchedule"];
    
    results = [self.blueData.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return results;
}

-(NSArray *)fetchLocations
{
    NSArray *results;
    NSError *error;
    
    results = [self.blueData.managedObjectContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Location"] error:&error];
    
    return results;
}

-(NSArray*)fetchBeaconGroups
{
    return [self.blueData.managedObjectContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"BeaconGroup"] error:nil];
}

@end
