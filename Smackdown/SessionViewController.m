//
//  SessionViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#define AbstractViewTag 42

#import <QuartzCore/QuartzCore.h>

#import "SessionViewController.h"
#import "NotesViewController.h"

@interface SessionViewController(Internal)
- (void)resetDataViews;
@end

@implementation SessionViewController
@synthesize session;
@synthesize speaker;

- (void)resetDataViews{
  if(session){
    [self.tableView reloadData];
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

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setSession:(Session *)newSession{
  session = newSession;
  
  NSError *fetchError;
  NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Speaker"];
  NSPredicate *pred = [NSPredicate predicateWithFormat:@"speakerID == %@", [session valueForKeyPath:@"properties.SpeakerURI"]];
  [req setPredicate:pred];
  [req setFetchLimit:1];
  
  NSArray *results = [[[LGAppDelegate sharedAppDelegate] managedObjectContext] executeFetchRequest:req error:&fetchError];
  if(results && [results count] > 0){
    self.speaker = [results objectAtIndex:0];
  }
  
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  switch (section) {
    case 1:
      return @"Abstract:";
      break;
      
    default:
      return nil;
      break;
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  switch (section) {
    case 0:
      return 4;
      break;

    default:
      return 1;
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if(indexPath.section == 1){
    return [[session valueForKeyPath:@"properties.Abstract"] sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(self.tableView.bounds.size.width, 1000)].height+10.0f;
  } else {
    return 44.0f;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if(section == 0) return 44.0f;
  return 22.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  if(section == 0){
    CGRect headerRect = CGRectMake(0, 0, self.tableView.bounds.size.width, 42.0f);
    UIView *plainHeader = [[UIView alloc] initWithFrame:headerRect];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerRect, 10, 2)];

    [plainHeader addSubview:titleLabel];
    
    plainHeader.backgroundColor = [UIColor whiteColor];
    plainHeader.layer.borderWidth = 1.0f;
    plainHeader.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    titleLabel.text = session.name;
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    return plainHeader;
  } else 
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSInteger section = indexPath.section;
  NSString *cellIdentifer = nil;
  UITableViewCell *cell = nil;
  cellIdentifer = (section == 0) ? @"mainSessionCell" : @"abstractCell";
  cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
  if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
  if (section == 1) {
    UITextView *tv = (UITextView *)[cell viewWithTag:AbstractViewTag];
    [tv setText:[session valueForKeyPath:@"properties.Abstract"]];
    tv.contentSize = CGSizeMake(cell.bounds.size.width, [[session valueForKeyPath:@"properties.Abstract"] sizeWithFont:[UIFont systemFontOfSize:15.0f]].height);
  } else {
    switch (indexPath.row) {
      case 0:
        cell.imageView.image = [UIImage imageNamed:@"speaker"];
        cell.textLabel.text = [session valueForKeyPath:@"properties.SpeakerName"];
        break;
      case 1:
        cell.imageView.image = [UIImage imageNamed:@"map"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ in %@", 
                               [session valueForKeyPath:@"startAt"],
                               [session valueForKeyPath:@"properties.Room"]];
        break;
      case 2:
        // where and when
        cell.imageView.image = [UIImage imageNamed:[[session valueForKeyPath:@"properties.Difficulty"] lowercaseString]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", 
                               [session valueForKeyPath:@"properties.Difficulty"],
                               [session valueForKeyPath:@"properties.Technology"]];
        break;
      case 3:
        cell.textLabel.text = [speaker valueForKeyPath:@"properties.TwitterHandle"];
        //         
      default:
        break;
    }
  }
  
  return cell;
}


@end
