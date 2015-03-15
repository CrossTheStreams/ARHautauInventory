//
//  Item.m
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/5/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "Item.h"

@implementation Item

@dynamic title;

+(instancetype) createInMoc:(NSManagedObjectContext*) moc {
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:moc];
    return item;
}

@end
