//
//  SessionViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "SessionViewController.h"
#import "NotesViewController.h"

@interface SessionViewController(Internal)
- (void)resetDataViews;
@end

@implementation SessionViewController
@synthesize session;
@synthesize titleView;
@synthesize speakerNameView;
@synthesize abstractView;
@synthesize roomView;
@synthesize categoryView;

- (void)resetDataViews{
  if(session){
    titleView.text = session.title;
    speakerNameView.text = session.speakerName;
    abstractView.text = session.abstract;
    categoryView.text = session.technology;
    roomView.text = session.room;
    
    [self.view setNeedsDisplay];
  }
}

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
  [self resetDataViews];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setSession:(Session *)newSession{
  session = newSession;
  [self resetDataViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"viewSessionNotes"]){
    NotesViewController *nvc = (NotesViewController *)[segue destinationViewController];
    nvc.session = session;
  }
}

- (IBAction)tweetSessionComment:(id)sender{
  if([TWTweetComposeViewController canSendTweet]){
    TWTweetComposeViewController *tweetController = [[TWTweetComposeViewController alloc] init];      
    [self presentModalViewController:tweetController animated:YES];
  }
}


@end
