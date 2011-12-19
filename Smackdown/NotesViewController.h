//
//  NotesViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 12/14/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeNoteViewController.h"
#import "NoteViewController.h"

@interface NotesViewController : UITableViewController<ComposeNoteDelegate> 

@property (nonatomic, retain) NSArray *sessions;
@property (nonatomic, retain) Session *session;

- (NSMutableDictionary *)noteAtIndexPath:(NSIndexPath *)indexPath;

@end
