//
//  Item.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/5/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Item : NSManagedObject

@property (strong, nonatomic) NSString *title;

+(instancetype) createInMoc:(NSManagedObjectContext*) moc;

@end
