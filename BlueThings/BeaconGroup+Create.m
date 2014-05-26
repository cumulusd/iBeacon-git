//
//  BeaconGroup+Create.m
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "BeaconGroup+Create.h"

@implementation BeaconGroup (Create)

+(BeaconGroup*)createLocationWithUUID:(NSString*)UUID withName:(NSString*)name inManagedObjectContext:(NSManagedObjectContext*)context
{
    BeaconGroup *beaconGroup = [NSEntityDescription insertNewObjectForEntityForName:@"BeaconGroup" inManagedObjectContext:context];
    beaconGroup.beaconUUID = UUID;
    beaconGroup.name = name;
    
    return beaconGroup;
}

@end
