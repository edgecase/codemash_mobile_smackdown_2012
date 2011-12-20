//
//  ExpandoObject.m
//  Smackdown
//
//  Created by Leon Gersing on 12/19/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "ExpandoObject.h"

@implementation ExpandoObject
@synthesize properties;
@dynamic propertyBag;

- (void)awakeFromFetch{
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:self.propertyBag];
  self.properties = [unarchiver decodeObjectForKey:@"properties"];
  [self dateProperty]; // memoize the date object because we sort on it.
  [unarchiver finishDecoding];
}

- (void)resetPropertyBag{
  if(properties){
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:properties forKey:@"properties"];
    [archiver finishEncoding];
    self.propertyBag = [NSData dataWithData:data];
  }
}

+ (id)createObjectOfType:(NSString *)entityName Attributes:(NSMutableDictionary *)attributes{
  
  NSManagedObjectContext *ctx = [[LGAppDelegate sharedAppDelegate] managedObjectContext];
  NSEntityDescription *sessionDesc = 
  [NSEntityDescription entityForName:entityName 
              inManagedObjectContext:ctx];
  id entity = [[NSManagedObject alloc] initWithEntity:sessionDesc insertIntoManagedObjectContext:ctx];
  [entity setValue:attributes forKeyPath:@"properties"];  
  [entity resetPropertyBag];
  return entity;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
  if(!properties)
    [self setValue:[NSMutableDictionary dictionaryWithCapacity:1] forKeyPath:@"properties"];
  
  [self setValue:value forKeyPath:[NSString stringWithFormat:@"properties.%@",key]];
}

- (id)valueForUndefinedKey:(NSString *)key{
  if(!properties){
    [self setValue:[NSMutableDictionary dictionaryWithCapacity:0] forKeyPath:@"properties"];
    return nil;
  }
  
  return [self valueForKeyPath:[NSString stringWithFormat:@"properties.%@", key]];
}

- (NSDate *)dateProperty{
  if(_parsedStart) return _parsedStart;
  NSString *preDate = [[self valueForKeyPath:@"properties.Start"] substringWithRange:NSMakeRange(6, 10)];
  _parsedStart = [NSDate dateWithTimeIntervalSince1970:[preDate intValue]];
  
  // compensate for lazy APIs.
  if ([[_parsedStart earlierDate:[NSDate date]] isEqualToDate:_parsedStart]) {
    _parsedStart = [NSDate dateWithTimeIntervalSince1970:1326290400];
  }
  return _parsedStart;
}


@end
