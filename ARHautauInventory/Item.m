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
@dynamic location;
@dynamic image;
@dynamic tags;

+(NSString*) entityName {
    return @"Item";
}

@end
