//
//  NSFileManager+Extentions.h
//  ARHautauInventory
//
//  Created by Andrew Hautau on 3/15/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extentions)

+(instancetype) createInMoc:(NSManagedObjectContext*) moc;

@end
