//
//  BNRImageStore.h
//  HomePwner
//
//  Created by Thomas Eng on 04.07.13.
//  Copyright (c) 2013 Thomas Eng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+ (BNRImageStore*)sharedStore;
- (void)setImage:(UIImage*)i forKey:(NSString*)s;
- (UIImage*)imageForKey:(NSString*)s;
- (void)deleteImageForKey:(NSString*)s;

@end
