//
//  Item.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/5/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+Extensions.h"
#import "Location.h"
#import "Image.h"
@class Image;

@interface Item : NSManagedObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) Image *image;
@property (strong, nonatomic) NSSet *tags;


@end
