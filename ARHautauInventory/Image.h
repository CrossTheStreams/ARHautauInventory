//
//  Image.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+Extensions.h"

@interface Image : NSManagedObject

@property (strong, nonatomic) NSString *url;

@end
