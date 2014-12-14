//
//  NSUserDefaults+Reminder.m
//  Flic
//
//  Created by TrungBQ on 12/13/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "NSUserDefaults+Reminder.h"

@implementation NSUserDefaults (Reminder)

- (void)saveCustomObject:(id<NSCoding>)object
                     forKey:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self setObject:encodedObject forKey:key];
    [self synchronize];
    
}

- (id<NSCoding>)loadCustomObjectWithKey:(NSString *)key {
    NSData *encodedObject = [self objectForKey:key];
    id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
