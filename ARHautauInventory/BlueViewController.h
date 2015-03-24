//
//  BlueViewController.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BlueViewController : NSViewController
@property (weak) IBOutlet NSTextField *itemNameLabel;
@property (weak, nonatomic) NSString * itemName;
@property (strong, nonatomic) NSString * locationURL;
@property (weak) IBOutlet NSButton *showLocation;
@property (weak) IBOutlet NSImageView *itemImage;

@end
