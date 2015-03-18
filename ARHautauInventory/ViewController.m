//
//  ViewController.m
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/5/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "ViewController.h"
#import "ConfigurableCoreDataStack.h"
#import "Item.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
//    for (int i = 0; i < 5; i++) {
//        Item *item = [Item createInMoc: [self moc]];
//        NSString *title = [NSString stringWithFormat: @"item %d", i + 1];
//        
//        [item setTitle: title];
//        NSError *saveError = nil;
//        
//        BOOL success = [[self moc] save: &saveError];
//        
//        if (!success) {
//            [[NSApplication sharedApplication] presentError:saveError];
//        }
//        NSLog(@"%@",item);
//    }
    
//    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
//    NSError *fetchError = nil;
//    NSArray *allItems = [moc executeFetchRequest:fr error:&fetchError];
    
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@",allItems);

    // delete all items
//    for (Item *singleItem in allItems) {
//        [moc deleteObject: singleItem];
//    }
//    
//    [moc save: nil];
    
    [self updateTableViewWithTitles:[self itemTitles]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(NSManagedObjectContext*) moc {
    return [[ConfigurableCoreDataStack defaultStack] managedObjectContext];
}

-(NSArray*) allItems {
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError *fetchError = nil;
    NSArray *items= [[self moc] executeFetchRequest:fr error:&fetchError];
    return items;
}

-(NSArray*) itemTitles {
    NSArray *items = [self allItems];
    NSArray *titles = [items valueForKey: @"title"];
    return titles;
}

- (IBAction)clickedShow:(id)sender {
    
    NSLog(@"clicked %s", __PRETTY_FUNCTION__);
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *vc = [sb instantiateControllerWithIdentifier:@"BlueVC"];
    
//    present as sheet
//    [self presentViewControllerAsSheet:vc];
    
//    present as modal window
//    [self presentViewControllerAsModalWindow:vc];
    
    
//    present as popover relative to rect
//    NSButton *btn = self.showButton;
//    [self presentViewController:vc
//        asPopoverRelativeToRect: btn.bounds
//                         ofView: btn
//                  preferredEdge: NSMaxYEdge
//                       behavior: NSPopoverBehaviorTransient];
 
    
}

-(void)updateTableViewWithTitles:(NSArray *)titles {
    [self setTitleArray: titles];
    [[self tableView] reloadData];
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"TableCellView" owner:nil];
    
    result.textField.stringValue = [self.titleArray objectAtIndex:row];
    
    if (row % 2) {
        [result.layer setBackgroundColor: [[NSColor lightGrayColor] CGColor]];
    }
    
    return result;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.titleArray count];
}




-(IBAction) clickedGetPics:(id)sender {

    NSOpenPanel *op = [NSOpenPanel openPanel];
    op.allowsMultipleSelection = YES;
    
    NSString *path = [@"~/Desktop" stringByExpandingTildeInPath];
    NSURL *url = [NSURL fileURLWithPath: path];
    [op setDirectoryURL: url];
    
    
    [op beginWithCompletionHandler:^(NSInteger result) {
        if (result == YES) {
            NSLog(@"%@",op.URLs);
            
            // for each url in urls
                //make core data Image entity
            // entity has UUID
            // copy image to secure location /com.myapp.Images/uuid.png
            
            NSError *error = nil;
            NSURL *mySecretURL = nil;
            
            [[NSFileManager defaultManager] copyItemAtURL: op.URL toURL: mySecretURL error: &error];
        }
        
    
    }];
    
}


@end
