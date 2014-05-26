//
//  BeaconGroup+Create.h
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "BeaconGroup.h"

@interface BeaconGroup (Create)
+(BeaconGroup*)createLocationWithUUID:(NSString*)UUID withName:(NSString*)name inManagedObjectContext:(NSManagedObjectContext*)context;
@end
