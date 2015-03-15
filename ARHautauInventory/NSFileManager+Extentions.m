//
//  NSFileManager+Extentions.m
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "NSFileManager+Extentions.h"

@implementation NSFileManager (Extentions)

+(instancetype) createInMoc:(NSManagedObjectContext*) moc {
    Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:moc];
    return image;
}

@end
