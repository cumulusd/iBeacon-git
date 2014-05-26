//
//  Location+Create.m
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "Location+Create.h"

@implementation Location (Create)
+(Location*)createLocationWithName:(NSString*)name withMajor:(NSInteger)major andMinor:(NSInteger)minor inManagedObjectContext:(NSManagedObjectContext*)context
{
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
    location.majorID = [NSNumber numberWithInteger:major];
    location.minorID = [NSNumber numberWithInteger:minor];
    location.name  = name;
    
    return  location;
}
@end
