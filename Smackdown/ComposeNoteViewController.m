//
//  ComposeNoteViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/14/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "ComposeNoteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ComposeNoteViewController (CameraDelegateMethods)

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
  
  [[picker parentViewController] dismissModalViewControllerAnimated: YES];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
  
  NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
  UIImage *imageToSave = nil;
  
  // Handle a still image capture
  if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
    
    imageToSave = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    if(!imageToSave)
      imageToSave = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Save the new image (original or edited) to the Camera Roll
    UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    if(!images) images = [NSMutableArray arrayWithCapacity:1];
    [images addObject:imageToSave];
    UIImageView *iv = [[UIImageView alloc] initWithImage:imageToSave];
    [imageScrollView addSubview:iv];
    iv.bounds = CGRectMake( (44 * [images count])+4, 2, 44, 44);
  }
  
  // Handle a movie capture
  if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
    
    NSString *moviePath = [[info objectForKey:
                            UIImagePickerControllerMediaURL] path];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
      UISaveVideoAtPathToSavedPhotosAlbum (
                                           moviePath, nil, nil, nil);
    }
  }
  
  [picker dismissModalViewControllerAnimated: YES];
}

@end

@implementation ComposeNoteViewController
@synthesize session;
@synthesize delegate;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

- (IBAction)takePicture:(id)sender{
  [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (IBAction)cancel:(id)sender{
  if (delegate && [delegate respondsToSelector:@selector(userDidCancel:)]) {
    [delegate userDidCancel:self];
  }
}

- (IBAction)save:(id)sender{
  
  Note *newNote = [Note createNote];
  
  newNote.created_at = [NSDate date];
  
  if([[textView text] length] > 2) newNote.body = [textView text];
  
  // TODO: allow for multiple images per note.
  if(images && [images count] > 0) newNote.image = [images objectAtIndex:0];
  
  [session addNotesObject:newNote];
  if (delegate && [delegate respondsToSelector:@selector(userCreatedNote:sender:)]) {
    [delegate userCreatedNote:newNote sender:self];
  }
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) theDelegate {
  
  if (([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypeCamera] == NO)
      || (theDelegate == nil)
      || (controller == nil))
    return NO;
  
  
  UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
  cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
  
  // Displays a control that allows the user to choose picture or
  // movie capture, if both are available:
  cameraUI.mediaTypes =
  [UIImagePickerController availableMediaTypesForSourceType:
   UIImagePickerControllerSourceTypeCamera ];
  
  // Hides the controls for moving & scaling pictures, or for
  // trimming movies. To instead show the controls, use YES.
  cameraUI.allowsEditing = YES;
  cameraUI.delegate = theDelegate;
  
  [controller presentModalViewController: cameraUI animated: YES];
  return YES;
}

@end
