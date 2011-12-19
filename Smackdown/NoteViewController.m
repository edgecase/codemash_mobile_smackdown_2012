//
//  NoteViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/14/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController(Internal)
- (void)bindData;
@end

@implementation NoteViewController
@synthesize note;
@synthesize session;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
  [self bindData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

- (void)bindData{
  if(note && session){
    noteView.text = [note objectForKey:@"body"];
    timeStampView.text = [note objectForKey:@"created_at"];
    self.title = sessionTitleView.text = session.title;
  } 
}

@end
