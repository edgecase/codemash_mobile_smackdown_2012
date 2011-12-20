//
//  Note.h
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Note : ExpandoObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Session *session;

@end
