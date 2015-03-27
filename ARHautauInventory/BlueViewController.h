//
//  BlueViewController.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Item.h"

@interface BlueViewController : NSViewController
@property (weak) IBOutlet NSTextField *itemNameLabel;
@property (weak, nonatomic) NSString * itemName;
@property (weak, nonatomic) NSString * locationURL;
@property (weak) IBOutlet NSButton *showLocation;
@property (weak) IBOutlet NSImageView *itemImage;
@property (weak, nonatomic) NSNumber * itemIndex;

@end
