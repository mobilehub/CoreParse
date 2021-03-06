//
//  CPShiftReduceActionTable.m
//  CoreParse
//
//  Created by Tom Davie on 05/03/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import "CPShiftReduceActionTable.h"

#import "CPItem.h"
#import "CPGrammarSymbol.h"

@implementation CPShiftReduceActionTable
{
    NSMutableDictionary **table;
    NSUInteger capacity;
}

- (id)initWithCapacity:(NSUInteger)initCapacity
{
    self = [super init];
    
    if (nil != self)
    {
        capacity = initCapacity;
        table = malloc(capacity * sizeof(NSMutableDictionary *));
        for (NSUInteger buildingState = 0; buildingState < capacity; buildingState++)
        {
            table[buildingState] = [[NSMutableDictionary alloc] init];
        }
    }
    
    return self;
}

- (void)dealloc
{
    for (NSUInteger state = 0; state < capacity; state++)
    {
        [table[state] release];
    }
    free(table);
    
    [super dealloc];
}

- (BOOL)setAction:(CPShiftReduceAction *)action forState:(NSUInteger)state name:(NSString *)token
{
    NSMutableDictionary *row = table[state];
    if (nil != [row objectForKey:token] && ![[row objectForKey:token] isEqual:action])
    {
        return NO;
    }
    [row setObject:action forKey:token];
    return YES;
}

- (CPShiftReduceAction *)actionForState:(NSUInteger)state token:(CPToken *)token
{
    return [table[state] objectForKey:token.name];
}

- (NSString *)description
{
    if (capacity > 0)
    {
        NSMutableString *s = [NSMutableString string];
        NSMutableSet *keys = [NSMutableSet set];
        NSUInteger width = 3;
        for (NSUInteger state = 0; state < capacity; state++)
        {
            [keys addObjectsFromArray:[table[state] allKeys]];
        }
        for (NSString *key in keys)
        {
            width = MAX(width, [key length]);
        }
        NSArray *orderedKeys = [keys allObjects];
        [s appendString:@"State | "];
        for (NSString *key in orderedKeys)
        {
            [s appendFormat:@"%@", key];
            NSUInteger numSpaces = 1 + width - [key length];
            for (NSUInteger numAdded = 0; numAdded < numSpaces; numAdded++)
            {
                [s appendString:@" "];
            }
        }
        [s appendString:@"\n"];
        
        NSUInteger idx = 0;
        for (NSUInteger state = 0; state < capacity; state++)
        {
            NSDictionary *row = table[state];
            [s appendFormat:@"%5d | ", idx];
            for (NSString *key in orderedKeys)
            {
                CPShiftReduceAction *action = [row objectForKey:key];
                NSUInteger numSpaces;
                if (nil == action)
                {
                    numSpaces = 1 + width;
                }
                else
                {
                    [s appendFormat:@"%@", action];
                    numSpaces = 1 + width - [[action description] length];
                }
                for (NSUInteger numAdded = 0; numAdded < numSpaces; numAdded++)
                {
                    [s appendString:@" "];
                }
            }
            [s appendString:@"\n"];
            idx++;
        }
             
        return s;
    }
    
    return @"";
}

- (NSString *)descriptionWithGrammar:(CPGrammar *)g
{
    if (capacity > 0)
    {
        NSMutableString *s = [NSMutableString string];
        NSMutableSet *keys = [NSMutableSet set];
        NSUInteger width = 3;
        for (NSUInteger state = 0; state < capacity; state++)
        {
            [keys addObjectsFromArray:[table[state] allKeys]];
        }
        for (NSString *key in keys)
        {
            width = MAX(width, [key length]);
        }
        NSArray *orderedKeys = [keys allObjects];
        [s appendString:@"State | "];
        for (NSString *key in orderedKeys)
        {
            [s appendFormat:@"%@", key];
            NSUInteger numSpaces = 1 + width - [key length];
            for (NSUInteger numAdded = 0; numAdded < numSpaces; numAdded++)
            {
                [s appendString:@" "];
            }
        }
        [s appendString:@"\n"];
        
        NSUInteger idx = 0;
        for (NSUInteger state = 0; state < capacity; state++)
        {
            NSDictionary *row = table[state];
            [s appendFormat:@"%5d | ", idx];
            for (NSString *key in orderedKeys)
            {
                CPShiftReduceAction *action = [row objectForKey:key];
                NSUInteger numSpaces;
                if (nil == action)
                {
                    numSpaces = 1 + width;
                }
                else
                {
                    [s appendFormat:@"%@", [action descriptionWithGrammar:g]];
                    numSpaces = 1 + width - [[action descriptionWithGrammar:g] length];
                }
                for (NSUInteger numAdded = 0; numAdded < numSpaces; numAdded++)
                {
                    [s appendString:@" "];
                }
            }
            [s appendString:@"\n"];
            idx++;
        }
        
        return s;
    }
    
    return @"";
}

@end
