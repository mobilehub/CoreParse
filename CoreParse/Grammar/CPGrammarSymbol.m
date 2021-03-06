//
//  CPGrammarSymbol.m
//  CoreParse
//
//  Created by Tom Davie on 13/03/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import "CPGrammarSymbol.h"


@implementation CPGrammarSymbol

@synthesize name;
@synthesize terminal;

+ (id)nonTerminalWithName:(NSString *)name
{
    return [[[self alloc] initWithName:name isTerminal:NO] autorelease];
}

+ (id)terminalWithName:(NSString *)name
{
    return [[[self alloc] initWithName:name isTerminal:YES] autorelease];
}

- (id)initWithName:(NSString *)initName isTerminal:(BOOL)isTerminal;
{
    self = [super init];
    
    if (nil != self)
    {
        [self setName:initName];
        [self setTerminal:isTerminal];
    }
    
    return self;
}

- (id)init
{
    return [self initWithName:@"" isTerminal:NO];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[CPGrammarSymbol class]])
    {
        CPGrammarSymbol *other = (CPGrammarSymbol *)object;
        return [other isTerminal] == [self isTerminal] && [[other name] isEqualToString:[self name]];
    }
    return NO;
}

- (NSUInteger)hash
{
    return [[self name] hash];
}

- (NSString *)description
{
    if ([self isTerminal])
    {
        return [NSString stringWithFormat:@"\"%@\"", [self name]];
    }
    else
    {
        return [NSString stringWithFormat:@"<%@>", [self name]];
    }
}

- (void)dealloc
{
    [name release];
    
    [super dealloc];
}

@end
