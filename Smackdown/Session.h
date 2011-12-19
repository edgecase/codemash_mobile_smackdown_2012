//
//  Session.h
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Agenda, Note, Speaker;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSString * difficulty;
@property (nonatomic, retain) NSString * lookup;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * speakerName;
@property (nonatomic, retain) NSString * speakerURI;
@property (nonatomic, retain) NSString * start;
@property (nonatomic, retain) NSString * technology;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) Agenda *agenda;
@property (nonatomic, retain) NSOrderedSet *notes;
@property (nonatomic, retain) Speaker *speaker;
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
