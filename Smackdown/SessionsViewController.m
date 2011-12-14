//
//  SessionsViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/13/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#define TITLE_TAG 10
#define SPEAKER_TAG 11
#define CATEGORY_TAG 12

#import "SessionsViewController.h"
#import "SessionViewController.h"
#import "CategorySelectionViewController.h"

@implementation SessionsViewController

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
  
  [spinner startAnimating];
  NSURL *sessionURL = [NSURL URLWithString:@"http://codemash.org/rest/sessions.json"];
  NSURLRequest *req = [NSURLRequest requestWithURL:sessionURL cachePolicy:NSURLCacheStorageAllowed timeoutInterval:2];
  [NSURLConnection sendAsynchronousRequest:req 
                                     queue:[NSOperationQueue currentQueue]
                         completionHandler:
   ^(NSURLResponse *resp, NSData *data, NSError *err) {
     if(err){
       [[[UIAlertView alloc] initWithTitle:@"Oh noes!" 
                                   message:[err description] 
                                  delegate:nil 
                         cancelButtonTitle:@"ok" 
                         otherButtonTitles:nil]
        show];
     } else {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
         NSError *jsonErr = nil;
         sessions = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonErr];
         dispatch_async(dispatch_get_main_queue(), ^{
           if(!jsonErr) [self.tableView reloadData];
           [spinner stopAnimating];
         });
       });
     }
  }];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return (sessions) ? [sessions count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell"];
  if(!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"sessionCell"];
  }
  
  NSMutableDictionary *session = [sessions objectAtIndex:indexPath.row];
  
  [[cell viewWithTag:TITLE_TAG] setValue:[session objectForKey:@"Title"] forKeyPath:@"text"];
  [[cell viewWithTag:SPEAKER_TAG] setValue:[session objectForKey:@"SpeakerName"] forKeyPath:@"text"];
  [[cell viewWithTag:CATEGORY_TAG] setValue:[session objectForKey:@"Technology"] forKeyPath:@"text"];
  
  if([[session objectForKey:@"isAttending"] boolValue]){
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
  } else {
    [cell setAccessoryType:UITableViewCellAccessoryNone];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self performSegueWithIdentifier:@"showSessionDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([[segue identifier] isEqualToString:@"showSessionDetails"]){
    SessionViewController *sessionController = (SessionViewController *)[segue destinationViewController];
    sessionController.session = [sessions objectAtIndex:[self.tableView indexPathForSelectedRow].row];
  } else if([[segue identifier] isEqualToString:@"showCategorySelection"]){
    CategorySelectionViewController *catController = (CategorySelectionViewController *)[segue destinationViewController];
    catController.categories = 
    [sessions valueForKeyPath:@"@distinctUnionOfObjects.Technology"];
                                
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  if (editingStyle == UITableViewCellEditingStyleDelete){
    NSMutableDictionary *session = [sessions objectAtIndex:indexPath.row];
    BOOL isAttending = [[session objectForKey:@"isAttending"] boolValue];
    [session setObject:[NSNumber numberWithBool:!isAttending] forKey:@"isAttending"];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  NSMutableDictionary *session = [sessions objectAtIndex:indexPath.row];

  BOOL isAttending = [[session objectForKey:@"isAttending"] boolValue];
  if(isAttending){
    return @"don't attend";
  } else {
    return @"attend";
  }
}

@end
