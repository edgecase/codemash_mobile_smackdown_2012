//
//  Speaker.h
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Speaker : ExpandoObject

@property (nonatomic, retain) NSOrderedSet *sessions;
@property (strong, nonatomic) NSString *blog;
@property (strong, nonatomic) NSString *twitter;
@property (strong, nonatomic) NSString *speakerID;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *name;

@end

@interface Speaker (CoreDataGeneratedAccessors)

- (void)insertObject:(Session *)value inSessionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSessionsAtIndex:(NSUInteger)idx;
- (void)insertSessions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSessionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSessionsAtIndex:(NSUInteger)idx withObject:(Session *)value;
- (void)replaceSessionsAtIndexes:(NSIndexSet *)indexes withSessions:(NSArray *)values;
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSOrderedSet *)values;
- (void)removeSessions:(NSOrderedSet *)values;
@end
