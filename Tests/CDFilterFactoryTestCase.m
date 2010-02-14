//
//  CDFilterFactoryTestCase.m
//  Persistence
//
//  Created by Ing. Jozef Bozek on 14.2.2010.
//
//	Copyright © 2010 Grapph. All Rights Reserved.
// 
//	Redistribution and use in source and binary forms, with or without 
//	modification, are permitted provided that the following conditions are met:
//
//	1. Redistributions of source code must retain the above copyright notice, this 
//	   list of conditions and the following disclaimer.
//
//	2. Redistributions in binary form must reproduce the above copyright notice, 
//	   this list of conditions and the following disclaimer in the documentation 
//	   and/or other materials provided with the distribution.
//
//	3. Neither the name of the author nor the names of its contributors may be used
//	   to endorse or promote products derived from this software without specific
//	   prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY GRAPPH "AS IS"
//	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
//	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "GHUnit.h"
#import "CDSearchCriteria.h"
#import "CDFilter.h"
#import "CDOrder.h"
#import "CDFilterDisjunction.h"
#import "CDFilterConjunction.h"
#import "CDLikeFilter.h"
#import "CDFilterFactory.h"

@interface CDFilterFactoryTestCase : GHTestCase {
	
}

@end

@implementation CDFilterFactoryTestCase

- (void)testEquals {
	
	CDFilter* order = [CDFilterFactory equals:@"prop" value:[NSNumber numberWithInt:1]];	
	GHAssertEquals(@"prop", order.property, nil);
	GHAssertEquals((NSUInteger)1, [order.bindValues count], nil);
	GHAssertEquals([NSNumber numberWithInt:1], [order.bindValues objectAtIndex:0], nil);
	
}

- (void)testLike {
	
	CDLikeFilter* order = (CDLikeFilter*)[CDFilterFactory like:@"prop" value:@"name"];	
	GHAssertEquals(@"prop", order.property, nil);
	GHAssertEquals((NSUInteger)1, [order.bindValues count], nil);
	NSString* bindValue = [order.bindValues objectAtIndex:0];
	GHAssertEqualStrings(@"name*", bindValue, nil);
	GHAssertTrue(order.caseSensitive, nil);
}

- (void)testLike_CaseInsensitive {
	
	CDLikeFilter* order = (CDLikeFilter*)[CDFilterFactory like:@"prop" value:@"name" caseSensitive:NO];	
	GHAssertEquals(@"prop", order.property, nil);
	GHAssertEquals((NSUInteger)1, [order.bindValues count], nil);
	NSString* bindValue = [order.bindValues objectAtIndex:0];
	GHAssertEqualStrings(@"name*", bindValue, nil);
	GHAssertFalse(order.caseSensitive, nil);
}

- (void)testEquals_CreatePredicate {
	
	CDFilter* order = [CDFilterFactory equals:@"name" value:@"Peter"];	
	GHAssertEquals(@"name", order.property, nil);
	GHAssertEquals((NSUInteger)1, [order.bindValues count], nil);
	GHAssertEquals(@"Peter", [order.bindValues objectAtIndex:0], nil);
	
	NSPredicate* predicate = [order createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertTrue([format hasPrefix:@"name"], nil);
	GHAssertTrue([format hasSuffix:@"\"Peter\""], nil);
	NSRange range = [format rangeOfString:@"=="];
	GHAssertEquals((NSUInteger)5, range.location, nil);
}

- (void)testNotEquals_CreatePredicate {
	
	CDFilter* order = [CDFilterFactory notEquals:@"name" value:@"Peter"];	
	GHAssertEquals(@"name", order.property, nil);
	GHAssertEquals((NSUInteger)1, [order.bindValues count], nil);
	GHAssertEquals(@"Peter", [order.bindValues objectAtIndex:0], nil);
	
	NSPredicate* predicate = [order createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertTrue([format hasPrefix:@"name"], nil);
	GHAssertTrue([format hasSuffix:@"\"Peter\""], nil);
	NSRange range = [format rangeOfString:@"!="];
	GHAssertEquals((NSUInteger)5, range.location, nil);
}

- (void)testLess_CreatePredicate {
	
	CDFilter* order = [CDFilterFactory less:@"name" value:@"Peter"];	
	GHAssertEquals(@"name", order.property, nil);
	GHAssertEquals((NSUInteger)1, [order.bindValues count], nil);
	GHAssertEquals(@"Peter", [order.bindValues objectAtIndex:0], nil);
	
	NSPredicate* predicate = [order createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertTrue([format hasPrefix:@"name"], nil);
	GHAssertTrue([format hasSuffix:@"\"Peter\""], nil);
	NSRange range = [format rangeOfString:@"<"];
	GHAssertEquals((NSUInteger)5, range.location, nil);
}

- (void)testGreather_CreatePredicate {
	
	CDFilter* order = [CDFilterFactory greather:@"name" value:@"Peter"];	
	GHAssertEquals(@"name", order.property, nil);
	GHAssertEquals((NSUInteger)1, [order.bindValues count], nil);
	GHAssertEquals(@"Peter", [order.bindValues objectAtIndex:0], nil);
	
	NSPredicate* predicate = [order createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertTrue([format hasPrefix:@"name"], nil);
	GHAssertTrue([format hasSuffix:@"\"Peter\""], nil);
	NSRange range = [format rangeOfString:@">"];
	GHAssertEquals((NSUInteger)5, range.location, nil);
}

- (void)testDisjunction {
	
	CDFilterDisjunction* disjunction = [CDFilterFactory disjunction];
	GHAssertNotNil(disjunction, nil);
	GHAssertNil(disjunction.filters, nil);
	GHAssertNil(disjunction.property, nil);
}


- (void)testConjuction {
	
	CDFilterConjunction* disjunction = [CDFilterFactory conjuction];
	GHAssertNotNil(disjunction, nil);
	GHAssertNil(disjunction.filters, nil);
	GHAssertNil(disjunction.property, nil);
}

- (void)testInValues {
	
	CDFilter* order = [CDFilterFactory inValues:@"name" values:[NSArray arrayWithObject:@"Peter"]];	
	GHAssertEquals(@"name", order.property, nil);
	GHAssertEquals((NSUInteger)1, [order.bindValues count], nil);
	NSArray *values = [order.bindValues objectAtIndex:0];
	GHAssertEquals(@"Peter", [values objectAtIndex:0], nil);
	
	NSPredicate* predicate = [order createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertEqualStrings(@"name IN {\"Peter\"}", format, nil);
}

@end
