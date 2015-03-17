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
    
    // Insert code here to initialize your application
    CoreDataStackConfiguration *config = [[CoreDataStackConfiguration alloc] init];
    [config setStoreType: NSSQLiteStoreType];
    [config setModelName: @"Item"];
    [config setAppIdentifier:@"com.ARHautauInventory"];
    [config setDataFileNameWithExtension:@"ARHautauInventory.sqlite"];
    [config setSearchPathDirectory: NSApplicationSupportDirectory];
    
    ConfigurableCoreDataStack *stack = [[ConfigurableCoreDataStack alloc] initWithConfiguration: config];
    
    NSManagedObjectContext * moc = stack.managedObjectContext;
    
    Item *item = [Item createInMoc: moc];
    

    [item setTitle:@"An error will be presented if this is nil"];
    
    NSError *saveError = nil;
    
    BOOL success = [moc save: &saveError];
    
    if (!success) {
        [[NSApplication sharedApplication] presentError:saveError];
    }
    
    NSLog(@"%@",item);
    
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError *fetchError = nil;
    NSArray *allItems = [moc executeFetchRequest:fr error:&fetchError];
    
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",allItems);

    // delete all items
    for (Item *singleItem in allItems) {
        [moc deleteObject: singleItem];
    }
    
    [moc save: nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
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
