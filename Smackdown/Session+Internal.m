//
//  Session+Internal.m
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "Session+Internal.h"

@implementation Session(Internal)

+ (Session *)sessionWithAttributes:(NSMutableDictionary *)attributes{

  NSEntityDescription *sessionDesc = 
  [NSEntityDescription entityForName:@"Session" 
              inManagedObjectContext:[[LGAppDelegate sharedAppDelegate] managedObjectContext]];
  Session *s = [[Session alloc] initWithEntity:sessionDesc insertIntoManagedObjectContext:[[LGAppDelegate sharedAppDelegate] managedObjectContext]];
  s.title = [attributes objectForKey:@"Title"];
  s.uri = [attributes objectForKey:@"URI"];
  s.abstract = [attributes objectForKey:@"Abstract"];
  s.room = [attributes objectForKey:@"Room"];
  s.speakerName = [attributes objectForKey:@"SpeakerName"];
  s.start = [attributes objectForKey:@"Start"];
  s.difficulty = [attributes objectForKey:@"Difficulty"];
  s.technology = [attributes objectForKey:@"Mobile"];
  s.speakerURI = [attributes objectForKey:@"SpeakerURI"];
  s.lookup = [attributes objectForKey:@"Lookup"];
  
  return s;
}

@end
