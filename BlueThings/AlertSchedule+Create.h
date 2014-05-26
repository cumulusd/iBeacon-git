//
//  AlertSchedule+Create.h
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "AlertSchedule.h"
#import "Location.h"

@interface AlertSchedule (Create)
+(AlertSchedule*)createAlertScheduleWithMessage:(NSString*)message forLocation:(Location*)theLocation withProximity:(NSInteger)proximity andAlertFrequency:(NSInteger)frequency inManagedObjectContext:(NSManagedObjectContext*)context;
@end
