//
//  SpeakersViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 1/3/12.
//  Copyright (c) 2012 //  Copyright (c) 2012 Leon Gersing
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

#import "SpeakersViewController.h"


@implementation SpeakersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Speaker"];
  [req setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"properties.Name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
  fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                        managedObjectContext:[[LGAppDelegate sharedAppDelegate] managedObjectContext]
                                                          sectionNameKeyPath:nil
                                                                   cacheName:@"Speakers"];
  fetchController.delegate = self;
  if([fetchController performFetch:nil]){
    [self cacheSpeakers];
  } else {
    exit(-1);
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - Table view delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath{
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                            withRowAnimation:UITableViewRowAnimationTop];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationBottom];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
  [self.tableView endUpdates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"speakerCell"];
  Speaker *obj = [fetchController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = [obj valueForKeyPath:@"properties.Name"];
  // Configure the cell with data from the managed object.
  return cell;
}

- (void)cacheSpeakers{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    NSError *fetchError;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Speaker"];
    int count = [[[LGAppDelegate sharedAppDelegate] managedObjectContext] countForFetchRequest:req error:&fetchError];
    if(count == 0){
      NSURLRequest *urlReq = [NSURLRequest requestWithURL:
                              [NSURL URLWithString:@"http://codemash.org/rest/speakers.json"]];
      
      [NSURLConnection sendAsynchronousRequest:urlReq
                                         queue:[NSOperationQueue currentQueue]
                             completionHandler:
       ^(NSURLResponse *resp, NSData *raw, NSError *reqErr){
         NSError *jsonErr = nil;
         NSArray *sessionDics = [NSJSONSerialization JSONObjectWithData:raw options:NSJSONReadingMutableContainers error:&jsonErr];
         for(NSMutableDictionary *dic in sessionDics){
           [Speaker createObjectOfType:@"Speaker" attributes:dic];
         }
       }];
    }
  });
  
}

@end
