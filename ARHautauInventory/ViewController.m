//
//  ViewController.m
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/5/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "ViewController.h"
#import "BlueViewController.h"
#import "ConfigurableCoreDataStack.h"
#import "Item.h"
#import "Location.h"
#import "Tag.h"
#import "Image.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    [self.searchField setDelegate:self];
    
//    [[ConfigurableCoreDataStack defaultStack] killCoreDataStack];
//
    NSManagedObject *moc = [self moc];
    
    // All the horcruxes in Harry Potter
    NSArray *horcruxNames = @[
                              @"Tom Riddle's diary",
                              @"HufflePuff's Cup",
                              @"Ravenclaw's Diadem",
                              @"Slytherin's Locket",
                              @"Marvolo Gaunt's Ring",
                              @"Nagini",
                              @"Harry Potter"
                              ];
    
    NSArray *locations = @[
                           @"https://www.google.com/maps/@54.039912,-2.793961,8z",
                           @"https://www.google.com/maps/@54.9327639,-1.8316274,8z",
                           @"https://www.google.com/maps/@55.819319,-4.682922,8z",
                           @"https://www.google.com/maps/@55.452262,-4.539413,8z",
                           @"https://www.google.com/maps/@51.503480,-0.139389,8z",
                           @"https://www.google.com/maps/@51.441035,-0.198441,8z",
                           @"https://www.google.com/maps/@51.476118,-0.070724,8z"
                           ];
    
    NSArray *tags = @[@"journal",
                      @"goblet",
                      @"jewel",
                      @"shiny",
                      @"Voldemort",
                      @"snake",
                      @"Daniel Radcliffe"
                      ];
    
    
    
    NSArray *currentItems = [self allItems];

    
    if ([currentItems count] == 0) {
        for (int i = 0; i < 7; i++) {
            Item *item = [Item createInMoc: moc];
            NSString *title = [horcruxNames objectAtIndex:i];
            
            [item setTitle: title];
            Location *location = [Location createInMoc:moc];
            [location setUrl: [locations objectAtIndex:i]];
            [item setLocation: location];
            Tag *itemTag = [Tag createInMoc:moc];
            [itemTag setName: [tags objectAtIndex:i]];
            NSSet *tagSet = [[NSSet alloc] initWithObjects: itemTag, nil];
            [item setTags: tagSet];
        }
    }
    
    NSError *saveError = nil;
    BOOL success = [[self moc] save: &saveError];
    
    if (!success) {
        [[NSApplication sharedApplication] presentError:saveError];
    }
    
    [self updateTableViewWithTitles:[self itemTitles]];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserverForName: @"addImageToItem" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSNumber *itemIndexNum = note.userInfo[@"itemIndex"];
        NSInteger itemIndex = [itemIndexNum integerValue];
        Image *image = note.userInfo[@"image"];
        Item *item = [[self allItems] objectAtIndex: itemIndex];
        
        [item setImage:image];
        [[self moc] save:nil];
    }];
    
    [nc addObserverForName: @"addTagToItem" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSManagedObjectContext *moc = [self moc];
        NSNumber *itemIndexNum = note.userInfo[@"itemIndex"];
        NSInteger itemIndex = [itemIndexNum integerValue];
        NSString *tagName = note.userInfo[@"name"];
        
        Tag *tag = [Tag createInMoc: moc];
        [tag setName:tagName];
        
        Item *item = [[self allItems] objectAtIndex: itemIndex];
        [item setTags: [[item tags] setByAddingObject:tag]];
        
        [moc save:nil];
    }];
    
    [nc addObserverForName: @"removeTagFromItem" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSManagedObjectContext *moc = [self moc];
        NSNumber *itemIndexNum = note.userInfo[@"itemIndex"];
        NSInteger itemIndex = [itemIndexNum integerValue];
        NSString *tagName = note.userInfo[@"name"];
        
        Item *item = [[self allItems] objectAtIndex: itemIndex];
        NSSet *tagSet = [[item tags] filteredSetUsingPredicate: [NSPredicate predicateWithFormat:@"name != %@", tagName]];

        [item setTags: tagSet];
        
        [moc save:nil];
    }];
    
}

-(void) controlTextDidChange:(NSNotification *)obj {

    
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


- (IBAction)didClickTableViewRow:(id)sender {
    NSTableView *tableView = sender;
    
    NSUInteger row = [tableView selectedRow];

    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    BlueViewController *vc = [sb instantiateControllerWithIdentifier:@"BlueVC"];
    NSArray *horcruxes = [self allItems];
    if ([horcruxes count] >= row) {
        
        Item *item = [horcruxes objectAtIndex:row];
        NSString *itemName = [item title];
        [vc setItemName: itemName];
        
        [vc setLocationURL: [NSString stringWithString: item.location.url]];
        vc.itemIndex = [NSNumber numberWithInteger: row];
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *tagArray = [item.tags sortedArrayUsingDescriptors:@[descriptor]];
        NSArray *tagNames = [tagArray valueForKey:@"name"];
        
        if ([tagNames count] > 0) {
            [vc setTagArray: tagNames];
        }
        
        if (item.image) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *directoryURL = [fileManager URLForDirectory: NSApplicationSupportDirectory inDomain: NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *imageLocation = [directoryURL URLByAppendingPathComponent: [@"com.ARHautauInventory/" stringByAppendingString: item.image.url]];
            
            [vc setImageFileURL: imageLocation];
            
        }
        
        //present as popover relative to rect
        [self presentViewController: vc
            asPopoverRelativeToRect: tableView.bounds
                             ofView: tableView
                      preferredEdge: NSMinXEdge
                           behavior: NSPopoverBehaviorTransient];
    }
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


@end
