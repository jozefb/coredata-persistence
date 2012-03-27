//
//  CDContainsFilter.m
//  Persistence
//
//  Created by Jozef Bozek on 27.3.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDContainsFilter.h"

@implementation CDContainsFilter

@synthesize caseSensitive;

-(id)initWithPropertyAndValue:(NSString*)aProperty value:(id)aValue {
	if (self = [super initWithPropertyAndValue:aProperty value:aValue operatorType:CDFilterOperatorContains]) {
		if (![aValue hasSuffix:@"*"]) {
			NSString* result = [NSString stringWithFormat:@"%@%@", aValue, @"*"];
			[_bindValues replaceObjectAtIndex:0 withObject:result];
		}
	}
	
	self.caseSensitive = YES;
	return self;
}

-(NSString*)operatorString {
	NSString* operatorString = [super operatorString];
	if (!caseSensitive) {
		operatorString = [NSString stringWithFormat:@"%@%@", operatorString, @"[c]"];
	}
	
	return operatorString;
}

@end
