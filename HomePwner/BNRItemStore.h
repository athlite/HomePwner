//
//  BNRItemStore.h
//  HomePwner
//
//  Created by Thomas Eng on 02.05.13.
//  Copyright (c) 2013 Thomas Eng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (BNRItemStore *)sharedStore;
- (void)removeItem:(BNRItem *)p;
- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;
- (NSArray *)allItems;
- (BNRItem *)createItem;

@end
