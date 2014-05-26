//
//  BeaconGroup.h
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface BeaconGroup : NSManagedObject

@property (nonatomic, retain) NSString * beaconUUID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *locations;
@end

@interface BeaconGroup (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

@end
