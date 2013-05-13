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
    
    return [[[BNRItemStore sharedStore] allItems] count];
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
    
    BNRItem *p = [[[BNRItemStore sharedStore] allItems]
                  objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[p description]];

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
@end
