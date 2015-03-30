//
//  ViewController.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/5/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property(strong, nonatomic) NSArray *titleArray;
@property (weak) IBOutlet NSTextField *searchField;

@property(strong, nonatomic) NSArray *currentItems;


@end

