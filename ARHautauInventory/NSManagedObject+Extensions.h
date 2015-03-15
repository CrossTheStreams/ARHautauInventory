//
//  NSManagedObject+Extensions.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Extensions)

+(NSString*) entityName;
+(instancetype) createInMoc:(NSManagedObjectContext*) moc;


@end
