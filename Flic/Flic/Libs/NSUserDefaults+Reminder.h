//
//  NSUserDefaults+Reminder.h
//  Flic
//
//  Created by TrungBQ on 12/13/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Reminder)

- (void)saveCustomObject:(id<NSCoding>)object
                     forKey:(NSString *)key;
- (id<NSCoding>)loadCustomObjectWithKey:(NSString *)key;

@end
