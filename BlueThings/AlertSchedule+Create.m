//
//  AlertSchedule+Create.m
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "AlertSchedule+Create.h"

@implementation AlertSchedule (Create)

+(AlertSchedule*)createAlertScheduleWithMessage:(NSString*)message forLocation:(Location*)theLocation withProximity:(NSInteger)proximity andAlertFrequency:(NSInteger)frequency inManagedObjectContext:(NSManagedObjectContext*)context
{
    AlertSchedule *alertSchedule = [NSEntityDescription insertNewObjectForEntityForName:@"AlertSchedule" inManagedObjectContext:context];
    alertSchedule.message = message;
    alertSchedule.locationEventTypeID = [NSNumber numberWithInteger:proximity];
    alertSchedule.alertFrequencyID = [NSNumber numberWithInteger:frequency];
    
    [theLocation addLocationAlertsObject:alertSchedule];
    
    return alertSchedule;
}

@end
