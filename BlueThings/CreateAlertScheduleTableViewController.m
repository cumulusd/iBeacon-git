//
//  CreateAlertScheduleTableViewController.m
//  BlueThings
//
//  Created by Daniel Bradford on 12/7/13.
//  Copyright (c) 2013 Daniel Bradford. All rights reserved.
//

#import "BlueAppDelegate.h"
#import "CreateAlertScheduleTableViewController.h"
#import "BlueData.h"
#import "BlueImperator.h"

@interface CreateAlertScheduleTableViewController ()
@property (weak,nonatomic) BlueData *blueData;
@property (weak,nonatomic) BlueImperator *imperator;
@property (strong,nonatomic) NSArray *locations;
@end

@implementation CreateAlertScheduleTableViewController

BOOL showDistancePicker;
CLProximity currentProximity;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    showDistancePicker = NO;
    currentProximity = CLProximityUnknown;
    
    BlueAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.blueData = appDelegate.blueData;
    self.imperator = appDelegate.imperator;
    self.locations = [self.blueData fetchLocations];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAlert:(UIBarButtonItem *)sender
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *textField = (UITextField*)[cell viewWithTag:100];
    
    if ([textField.text length] && currentProximity != CLProximityUnknown) {
        [self.blueData createAlertScheduleWithMessage:textField.text forLocation:[self.locations objectAtIndex:0] withProximity:currentProximity andAlertFrequency:AlertFrequencyOnlyOnce];
        
        [self.imperator didUpdateAlertSchedule];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

// target action for choosing distance

- (IBAction)didChooseDistanceFar:(UIButton *)sender {
    currentProximity = CLProximityFar;
    [self updateChosenDistance:@"Far"];
}

- (IBAction)didChooseDistanceNear:(UIButton *)sender {
    currentProximity = CLProximityNear;
    [self updateChosenDistance:@"Near"];
}

- (IBAction)didChooseDistanceImmediate:(UIButton *)sender {
    currentProximity = CLProximityImmediate;
    [self updateChosenDistance:@"Immediate"];

}

-(void)updateChosenDistance:(NSString*)distance
{
    UILabel *distanceLabel = (UILabel*)[self.tableView viewWithTag:999];
    distanceLabel.text = distance;
}

// UITableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        showDistancePicker = !showDistancePicker;
        [UIView animateWithDuration:0.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        if(showDistancePicker)
        {
            return 115;
        }
        else{
            return 0;
        }
    }
    else
        return self.tableView.rowHeight;
    
}


@end
