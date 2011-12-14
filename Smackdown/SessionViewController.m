//
//  SessionViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "SessionViewController.h"

@implementation SessionViewController
@synthesize session;
@synthesize titleView;
@synthesize speakerNameView;
@synthesize abstractView;

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
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  if(session){
    titleView.text = [session objectForKey:@"Title"];
    speakerNameView.text = [session objectForKey:@"SpeakerName"];
    abstractView.text = [session objectForKey:@"Abstract"];
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setSession:(NSMutableDictionary *)newSession{
  session = newSession;
  titleView.text = [session objectForKey:@"Title"];
  speakerNameView.text = [session objectForKey:@"SpeakerName"];
  abstractView.text = [session objectForKey:@"Abstract"];
  [self.view setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return YES;
}

@end
