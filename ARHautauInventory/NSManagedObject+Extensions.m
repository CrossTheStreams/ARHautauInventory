//
//  NSManagedObject+Extensions.m
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "NSManagedObject+Extensions.h"

@implementation NSManagedObject (Extensions)

+(NSString*) entityName {
    @throw @"Override in subclass";
}

+(instancetype) createInMoc:(NSManagedObjectContext*) moc {
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
    return object;
}

@end
