//
//  ItemsViewController.m
//  HomePwner
//
//  Created by Thomas Eng on 02.05.13.
//  Copyright (c) 2013 Thomas Eng. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation ItemsViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
        for(int i=0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count] + 1;
}

- (UITableViewCell *)tableView: (UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];

    if(!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"UITableViewCell"];
    }
    
    BNRItem *p;
    
    if( [[[BNRItemStore sharedStore] allItems] count] > [indexPath row] ) {
        p = [[[BNRItemStore sharedStore] allItems]
                      objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[p description]];
    }else {
        [[cell textLabel] setText:@"No more rows"];
    }
    
    //NSLog(@"%d %@", [indexPath row], p);
    
    return cell;
}


- (UIView *)headerView
{
    
    if(!headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)sec
{
    return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)sec
{
    return [[self headerView] bounds].size.height;
}

- (IBAction)toggleEditingMode:(id)sender
{
    
    if( [self isEditing] ) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (IBAction)addNewItem:(id)sender
{
    
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                            withRowAnimation:UITableViewRowAnimationTop];
}


- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{

    BNRItemStore *ps = [BNRItemStore sharedStore];
    NSArray *items = [ps allItems];
    BNRItem *p = [items objectAtIndex:[indexPath row]];
    [ps removeItem:p];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
}


- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    if( [[[BNRItemStore sharedStore] allItems] count] <= [destinationIndexPath row] ) {
        [tableView reloadData];
        return;
    }
    
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row]
                                        toIndex:[destinationIndexPath row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] < [[[BNRItemStore sharedStore] allItems] count] ? YES : NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [[[BNRItemStore sharedStore] allItems] count] <= [indexPath row] ) return;
    
    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    BNRItem *selectedItem = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [detailViewController setItem:selectedItem];
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

@end

