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
@interface Item : NSManagedObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSSet *images;


@end
