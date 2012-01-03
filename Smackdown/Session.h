//
//  Session.h
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Speaker;

@interface Session : ExpandoObject

@property BOOL precompiler;
@property BOOL attending;
@property (nonatomic, retain) NSOrderedSet *notes;
@property (nonatomic, retain) Speaker *speaker;
@property (nonatomic, retain) NSDate *startAt;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *timeSlot;
@property (strong, nonatomic) NSString *sessionID;

@end

@interface Session (CoreDataGeneratedAccessors)

- (void)insertObject:(Note *)value inNotesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromNotesAtIndex:(NSUInteger)idx;
- (void)insertNotes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeNotesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInNotesAtIndex:(NSUInteger)idx withObject:(Note *)value;
- (void)replaceNotesAtIndexes:(NSIndexSet *)indexes withNotes:(NSArray *)values;
- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSOrderedSet *)values;
- (void)removeNotes:(NSOrderedSet *)values;
@end
