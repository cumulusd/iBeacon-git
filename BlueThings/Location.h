//
//  Location.h
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlertSchedule, BeaconGroup;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * majorID;
@property (nonatomic, retain) NSNumber * minorID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) BeaconGroup *beaconGroup;
@property (nonatomic, retain) NSSet *locationAlerts;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addLocationAlertsObject:(AlertSchedule *)value;
- (void)removeLocationAlertsObject:(AlertSchedule *)value;
- (void)addLocationAlerts:(NSSet *)values;
- (void)removeLocationAlerts:(NSSet *)values;

@end
