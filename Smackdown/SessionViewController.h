//
//  SessionViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *titleView;
@property (nonatomic, retain) IBOutlet UILabel *speakerNameView;
@property (nonatomic, retain) IBOutlet UILabel *roomView;
@property (nonatomic, retain) IBOutlet UILabel *categoryView;
@property (nonatomic, retain) IBOutlet UITextView *abstractView;
@property (nonatomic, retain) Session *session;

- (IBAction)tweetSessionComment:(id)sender;

@end
