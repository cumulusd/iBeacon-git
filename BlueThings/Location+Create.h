//
//  Location+Create.h
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "Location.h"

@interface Location (Create)
+(Location*)createLocationWithName:(NSString*)name withMajor:(NSInteger)major andMinor:(NSInteger)minor inManagedObjectContext:(NSManagedObjectContext*)context;
@end
