//
//  BlueViewController.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Item.h"

@interface BlueViewController : NSViewController <NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *itemNameLabel;
@property (weak, nonatomic) NSString * itemName;
@property (strong, nonatomic) NSString * locationURL;
@property (strong, nonatomic) NSURL * imageFileURL;
@property (strong, nonatomic) NSArray *tagArray;
@property (weak) IBOutlet NSButton *showLocation;
@property (weak) IBOutlet NSImageView *itemImage;
@property (weak, nonatomic) NSNumber * itemIndex;
@property (weak) IBOutlet NSTextField *tagTextField;
@property (weak) IBOutlet NSTextField *tagsField;
@property (weak) IBOutlet NSButton *addTagButton;
@property (weak) IBOutlet NSButton *removeTagButton;
@end
