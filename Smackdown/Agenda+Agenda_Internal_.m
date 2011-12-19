//
//  Agenda+Agenda_Internal_.m
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "Agenda+Agenda_Internal_.h"
static Agenda *sharedAgenda = nil;

@implementation Agenda (Agenda_Internal_)

+ (Agenda *)sharedAgenda{
  if(sharedAgenda) return sharedAgenda;
  NSManagedObjectContext *ctx = [[LGAppDelegate sharedAppDelegate] managedObjectContext];
  NSEntityDescription *agendDesc = 
  [NSEntityDescription entityForName:@"Agenda" inManagedObjectContext:ctx];
  
  NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Agenda"];
  NSArray *array = [ctx executeFetchRequest:req error:nil];
  if([array count] == 1){
    sharedAgenda = [array objectAtIndex:0];
  } else {
    sharedAgenda = [[Agenda alloc] initWithEntity:agendDesc insertIntoManagedObjectContext:ctx];
  }
  return sharedAgenda;
}

+ (BOOL)isAttendingSession:(Session *)session{
  return [[sharedAgenda sessions] containsObject:session];
}

@end
