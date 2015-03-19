//
//  BlueViewController.m
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "BlueViewController.h"

@interface BlueViewController ()

@end

@implementation BlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self itemNameLabel] setStringValue:[self itemName]];
    // Do view setup here.
}

- (IBAction)clickedShowLocation:(id)sender {
    [self openURLWithString: [self locationURL]];
}

-(void) openURLWithString:(NSString*) string {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:string]];
}

@end
