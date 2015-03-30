//
//  BlueViewController.m
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "BlueViewController.h"
#import "Image.h"
#import "ConfigurableCoreDataStack.h"
#import "ViewController.h"

@interface BlueViewController ()

@end

@implementation BlueViewController

-(void) viewWillAppear {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self tagTextField] setDelegate:self];
    [[self itemNameLabel] setStringValue:[self itemName]];
    [[self itemImage] setImage: [[NSImage alloc] initByReferencingURL: self.imageFileURL]];
    [[self removeTagButton] setEnabled: NO];
    
    [self updateTagsField];

}

-(void) updateTagsField {
    [[self tagsField] setStringValue:@""];
    
    NSUInteger tagCount = [[self tagArray] count];
    
    for (int i = 0; i < tagCount; i++) {
        NSString *nextTag = [[self tagArray] objectAtIndex:i];
        NSString *tagString = [[self.tagsField stringValue] stringByAppendingString: nextTag];
        [self.tagsField setStringValue: tagString];
        if (i != tagCount - 1) {
            NSString *tagStringWithComma = [[self.tagsField stringValue] stringByAppendingString: @", "];
            [self.tagsField setStringValue: tagStringWithComma];
        }
    }
}

- (IBAction)clickedShowLocation:(id)sender {
    [self openURLWithString: [self locationURL]];
}

-(void) openURLWithString:(NSString*) string {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:string]];
}


-(IBAction) clickedSelectImage:(id)sender {
    
    NSOpenPanel *op = [NSOpenPanel openPanel];
    //op.allowsMultipleSelection = YES;
    
    NSString *path = [@"~/Desktop" stringByExpandingTildeInPath];
    NSURL *url = [NSURL fileURLWithPath: path];
    [op setDirectoryURL: url];
    
    [op beginWithCompletionHandler:^(NSInteger result) {
        if (result == YES) {
            NSLog(@"%@",op.URLs);
            NSURL *url = op.URL;
            if (url) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                // fetch moc
                NSManagedObjectContext *moc = [[ConfigurableCoreDataStack defaultStack] managedObjectContext];
                // create image object
                Image *image = [Image createInMoc:moc];
        
                // create copy file path
                NSString *uuid = [[[image objectID] URIRepresentation] lastPathComponent];
                // TODO: Why does this not work yet??
                
                NSURL *directoryURL = [fileManager URLForDirectory: NSApplicationSupportDirectory inDomain: NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                NSURL *copyLocation = [directoryURL URLByAppendingPathComponent: [@"com.ARHautauInventory/" stringByAppendingString: [uuid stringByAppendingString:@".jpg"]]];

                NSError *error = [[NSError alloc] init];
                // copy the image file
                BOOL success = [fileManager copyItemAtURL: op.URL toURL: copyLocation error: &error];
                
                NSLog(@"successful? %d", success);
                
                if (!success) {
                    NSLog([error description]);
                }
                
                // set the url of the copy
                
                [image setUrl: [copyLocation lastPathComponent]];
                
                // save moc
                [moc save:nil];
                
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                
                [nc postNotificationName: @"addImageToItem" object:nil userInfo: @{@"image" : image, @"itemIndex" : [self itemIndex] }];
                
            }
        }
        
    }];
    
}

-(void) controlTextDidChange:(NSNotification *)obj {
    NSArray *tagNames = [self tagArray];
    NSString *tagTextFieldString = [self.tagTextField stringValue];
    BOOL containsTagName = [tagNames containsObject: tagTextFieldString];
    [[self addTagButton] setEnabled: !containsTagName];
    [[self removeTagButton] setEnabled: containsTagName];
}

- (IBAction)addTagToItem:(id)sender {
    NSString *name = [[self tagTextField] stringValue];
    if (!name) {
        name = @"";
    }
    NSString *trimmedName = [name stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    if (![trimmedName isEqualToString:@""]) {
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [[self tagTextField] setStringValue:@""];
        [nc postNotificationName: @"addTagToItem" object:nil userInfo: @{@"name" : trimmedName, @"itemIndex" : [self itemIndex] }];
    }
    NSArray *unsortedTagNames = [[self tagArray] arrayByAddingObject: trimmedName];
    NSArray *sortedTagNmes = [unsortedTagNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [self setTagArray: sortedTagNmes];
    [self updateTagsField];
}


- (IBAction)removeTagFromItem:(id)sender {
    NSString *name = [[self tagTextField] stringValue];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [[self tagTextField] setStringValue:@""];
    [nc postNotificationName: @"removeTagFromItem" object:nil userInfo: @{@"name" : name, @"itemIndex" : [self itemIndex] }];

    NSIndexSet* indexes = [[self tagArray] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ![obj isEqualToString: name];
    }];
    NSArray* newTags = [[self tagArray] objectsAtIndexes:indexes];
    [self setTagArray: newTags];
    [self updateTagsField];
}

@end
