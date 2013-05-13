//
//  ItemsViewController.h
//  HomePwner
//
//  Created by Thomas Eng on 02.05.13.
//  Copyright (c) 2013 Thomas Eng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController
{
    IBOutlet UIView *headerView;
}
- (UIView *)headerView;
- (IBAction)addNewItem:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;
@end
