//
//  NoteViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 12/14/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteViewController : UIViewController{
  IBOutlet UILabel *sessionTitleView;
  IBOutlet UILabel *timeStampView;
  IBOutlet UITextView *noteView;
}

@property (nonatomic, retain) NSMutableDictionary *note;
@property (nonatomic, retain) NSMutableDictionary *session;

@end
