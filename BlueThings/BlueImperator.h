//
//  BlueImperator.h
//  BlueThings
//
//  Created by Daniel Bradford on 12/8/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueImperator : NSObject


-(id)init;
-(void)startMonitoring;

-(void)didAwakeInBackgroundWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

-(void)didUpdateAlertSchedule;
-(void)didEnterBackground;
-(void)didEnterForeground;

@end
