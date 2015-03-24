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
                // fetch moc
                NSManagedObjectContext *moc = [[ConfigurableCoreDataStack defaultStack] managedObjectContext];
                // create image object
                Image *image = [Image createInMoc:moc];
        
                // create copy file path
                NSString *uuid = [[[image objectID] URIRepresentation] lastPathComponent];
                // TODO: Why does this not work yet??
                NSString *filePath = [[@"~/Library/com.ARHautauInventory/" stringByAppendingString: uuid] stringByAppendingString:@".png"];
                NSURL *copyLocation = [NSURL fileURLWithPath: filePath];

                // copy the image file
                [[NSFileManager defaultManager] copyItemAtURL: op.URL toURL: copyLocation error: nil];
                
                // set the url of the copy
                [image setUrl: [copyLocation lastPathComponent]];
                // save moc
                [moc save:nil];
                
                NSImage *uiImage = [[NSImage alloc] initWithContentsOfURL:copyLocation];
                [self setItemImage:uiImage];
            }
        }
        
    }];
    
}

@end
