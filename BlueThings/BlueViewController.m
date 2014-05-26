//
//  BlueViewController.m
//  BlueThings
//
//  Created by Daniel Bradford on 11/30/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "BlueViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BlueAppDelegate.h"
#import "BlueData.h"
#import "AlertSchedule+Create.h"
#import "Location+Create.h"
#import "BlueImperator.h"

@interface BlueViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) BlueData *blueData;
@property (strong, nonatomic) NSArray *tableData;
@property (weak, nonatomic) BlueImperator *imperator;
@end

@implementation BlueViewController

BOOL firstLoad;

@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    BlueAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.blueData = appDelegate.blueData;
    self.imperator = appDelegate.imperator;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    firstLoad = YES;
    
    NSLog(@"view did load");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableData = [self.blueData fetchAlertSchedule];
    [self.tableView reloadData];
    
    if(firstLoad)
    {
        firstLoad = NO;
        [self.imperator startMonitoring];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TableView delegate & datasource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlertCell";
    NSString *strAlertFrequency, *strProximity, *strLocation;
    CLProximity proximity;
    AlertFrequency frequency;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    AlertSchedule *alertSchedule = (AlertSchedule*)[self.tableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = alertSchedule.message;
    
    
    
    proximity = (CLProximity)[alertSchedule.locationEventTypeID integerValue];
    frequency = (AlertFrequency)[alertSchedule.alertFrequencyID integerValue];
    strLocation = ((Location*)alertSchedule.alertLocation).name;
    
    if(proximity == CLProximityFar) strProximity = @"some what close to";
    if(proximity == CLProximityNear) strProximity = @"near";
    if(proximity == CLProximityImmediate) strProximity = @"right next to";
    
    if(frequency == AlertFrequencyAlways) strAlertFrequency = @"every time";
    if( frequency == AlertFrequencyDefinedTimesAndDaysOfWeek) strAlertFrequency = @"";
    if(frequency == AlertFrequencyOnlyOnce) strAlertFrequency = @"the next time";
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Will alert %@ when you are %@ the %@", strAlertFrequency, strProximity, strLocation];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.blueData removeAlertSchedule:[self.tableData objectAtIndex:indexPath.row]];
        self.tableData = [self.blueData fetchAlertSchedule];
        [self.imperator didUpdateAlertSchedule];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
