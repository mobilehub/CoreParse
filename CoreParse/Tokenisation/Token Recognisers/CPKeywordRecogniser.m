//
//  CPKeywordRecogniser.m
//  CoreParse
//
//  Created by Tom Davie on 12/02/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import "CPKeywordRecogniser.h"

@interface CPKeywordRecogniser ()
{
    NSString *keyword;
}

@end

@implementation CPKeywordRecogniser

@synthesize keyword;
@synthesize invalidFollowingCharacters;

+ (id)recogniserForKeyword:(NSString *)keyword
{
    return [[[self alloc] initWithKeyword:keyword] autorelease];
}

- (id)initWithKeyword:(NSString *)initKeyword
{
    return [self initWithKeyword:initKeyword invalidFollowingCharacters:nil];
}

+ (id)recogniserForKeyword:(NSString *)keyword invalidFollowingCharacters:(NSCharacterSet *)invalidFollowingCharacters
{
    return [[[self alloc] initWithKeyword:keyword invalidFollowingCharacters:invalidFollowingCharacters] autorelease];
}

- (id)initWithKeyword:(NSString *)initKeyword invalidFollowingCharacters:(NSCharacterSet *)initInvalidFollowingCharacters
{
    self = [super init];
    
    if (nil != self)
    {
        [self setKeyword:initKeyword];
        [self setInvalidFollowingCharacters:initInvalidFollowingCharacters];
    }
    
    return self;
}

- (id)init
{
    return [self initWithKeyword:@" "];
}

- (void)dealloc
{
    [keyword release];
    [invalidFollowingCharacters release];
    
    [super dealloc];
}

- (CPToken *)recogniseTokenInString:(NSString *)tokenString currentTokenPosition:(NSUInteger *)tokenPosition
{
    NSString *kw = [self keyword];
    NSUInteger kwLength = [kw length];
    NSUInteger remainingChars = [tokenString length] - *tokenPosition;
    if (remainingChars >= kwLength)
    {
        if ([[tokenString substringWithRange:NSMakeRange(*tokenPosition, kwLength)] isEqualToString:kw])
        {
            if (remainingChars == kwLength || nil == invalidFollowingCharacters || [tokenString rangeOfCharacterFromSet:invalidFollowingCharacters options:0x0 range:NSMakeRange(*tokenPosition + kwLength, 1)].location == NSNotFound)
            {
                *tokenPosition = *tokenPosition + kwLength;
                return [CPKeywordToken tokenWithKeyword:kw];
            }
        }
    }
    
    return nil;
}

@end
