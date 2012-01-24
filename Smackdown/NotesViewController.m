//
//  NotesViewController.m
//  Smackdown
//
//  Created by Leon Gersing on 12/14/11.
//  Copyright (c) 2011 //  Copyright (c) 2012 Leon Gersing
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

#import "NotesViewController.h"
#import <objc/message.h>

@interface NotesViewController(Internal)
- (void)addSessionNote:(UIStoryboardSegue *)segue;
- (void)viewSessionNote:(UIStoryboardSegue *)segue;
@end

@implementation NotesViewController
@synthesize sessions;
@synthesize session;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
  return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
  return (sessions) ? [sessions count] : 1;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    //return (session) ? [[session objectForKey:@"notes"] count] : [[[sessions objectAtIndex:section] objectForKey:@"notes"] count];
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"notesListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
  
  NSMutableDictionary *note = [self noteAtIndexPath:indexPath];
  cell.textLabel.text = [note objectForKey:@"body"];
  cell.detailTextLabel.text = [note objectForKey:@"created_at"];
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSMutableDictionary *)noteAtIndexPath:(NSIndexPath *)indexPath{
  if(sessions){
    return [[[sessions objectAtIndex:indexPath.section] objectForKey:@"notes"] objectAtIndex:indexPath.row];
  } else {
    return [session.notes objectAtIndex:indexPath.row];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([[segue identifier] isEqualToString:@"addSessionNote"]) {
    [self addSessionNote:segue];
  }
  if ([[segue identifier] isEqualToString:@"viewSessionNote"]) {
    [self viewSessionNote:segue];
  }
}

- (void)addSessionNote:(UIStoryboardSegue *)segue{
  ComposeNoteViewController *vc = (ComposeNoteViewController *)[segue destinationViewController];
  vc.delegate = self;
  vc.session = session;
}

- (void)viewSessionNote:(UIStoryboardSegue *)segue{
  NoteViewController *vc = (NoteViewController *)[segue destinationViewController];
  [vc setNote:[self noteAtIndexPath:[self.tableView indexPathForSelectedRow]]];
}

- (void)userDidCancel:(id)sender{
  [self dismissModalViewControllerAnimated:YES];
}

- (void)userCreatedNote:(NSMutableDictionary *)newNote sender:(id)sender{
  [self.tableView reloadData];
  [self dismissModalViewControllerAnimated:YES];
}

@end
