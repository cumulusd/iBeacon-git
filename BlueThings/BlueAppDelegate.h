//
//  BlueAppDelegate.h
//  BlueThings
//
//  Created by Daniel Bradford on 11/30/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueData.h"
#import "BlueImperator.h"

@interface BlueAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) BlueData *blueData;

@property (strong, nonatomic) BlueImperator *imperator;

@end
