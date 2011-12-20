//
//  ExpandoObject.h
//  Smackdown
//
//  Created by Leon Gersing on 12/19/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpandoObject : NSManagedObject{
  NSMutableDictionary *properties;
  NSDate *_parsedStart;
}

@property (nonatomic, retain) NSData *propertyBag;
@property (nonatomic, retain) NSMutableDictionary *properties;

+ (id)createObjectOfType:(NSString *)entityName Attributes:(NSMutableDictionary *)attributes;
- (NSDate *)dateProperty;
- (void)resetPropertyBag;

@end
