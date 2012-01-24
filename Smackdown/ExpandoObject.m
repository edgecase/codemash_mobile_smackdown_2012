//
//  ExpandoObject.m
//  Smackdown
//
//  Created by Leon Gersing on 12/19/11.
//  Copyright (c) 2011 //  Copyright (c) 2012 Leon Gersing
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

#import "ExpandoObject.h"

@implementation ExpandoObject
@dynamic properties;

+ (id)createObjectOfType:(NSString *)entityName attributes:(NSMutableDictionary *)attributes{
  
  NSManagedObjectContext *ctx = [[LGAppDelegate sharedAppDelegate] managedObjectContext];
  NSEntityDescription *sessionDesc = 
  [NSEntityDescription entityForName:entityName 
              inManagedObjectContext:ctx];
  id entity = [[NSManagedObject alloc] initWithEntity:sessionDesc insertIntoManagedObjectContext:ctx];
  [entity setValue:attributes forKeyPath:@"properties"];  
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
