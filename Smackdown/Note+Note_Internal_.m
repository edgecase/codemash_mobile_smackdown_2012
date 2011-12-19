//
//  Note+Note_Internal_.m
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "Note+Note_Internal_.h"

@implementation Note (Note_Internal_)

+ (Note *)createNote{
  NSManagedObjectContext *ctx = 
  [[LGAppDelegate sharedAppDelegate] managedObjectContext];
  NSEntityDescription *desc = 
  [NSEntityDescription entityForName:@"Note" inManagedObjectContext:ctx];
  
  return [[Note alloc] initWithEntity:desc insertIntoManagedObjectContext:ctx];
}

@end
