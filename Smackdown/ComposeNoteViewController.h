//
//  ComposeNoteViewController.h
//  Smackdown
//
//  Created by Leon Gersing on 12/14/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComposeNoteDelegate <NSObject>
@optional
- (void)userDidCancel:(id)sender;
- (void)userCreatedNote:(Note *)newNote sender:(id)sender;

@end

@interface ComposeNoteViewController : UIViewController<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
  IBOutlet UIScrollView *imageScrollView;
  IBOutlet UITextView *textView;
  NSMutableArray *images;
}

@property (nonatomic, retain) Session *session;
@property (nonatomic, retain) id<ComposeNoteDelegate> delegate;

- (IBAction)takePicture:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
@end
