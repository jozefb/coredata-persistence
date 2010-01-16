//
//  Persistence
//
//  Created by Ing. Jozef Bozek on 29.5.2009.
//
//	Copyright © 2009 Grapph. All Rights Reserved.
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

@interface CDFilterJunctionTestCase : GHTestCase {	
}
@end

@implementation CDFilterJunctionTestCase

- (BOOL)shouldRunOnMainThread { return YES; }

- (void)setUp {
}

- (void)tearDown {
}


- (void)testDisjunction {
	
	CDFilterDisjunction* junction = [CDFilter disjunction];
	GHAssertNotNil(junction, nil);
	GHAssertNil(junction.filters, nil);
	
	CDFilter* filter1 = [CDFilter equals:@"name" value:@"Peter"];	
	[junction add:filter1];
	
	CDFilter* filter2 = [CDFilter equals:@"name" value:@"Milan"];	
	[junction add:filter2];
	
	GHAssertEquals((NSUInteger)2, [[junction filters] count], nil);
	GHAssertEquals(filter1, [[junction filters] objectAtIndex:0], nil);
	GHAssertEquals(filter2, [[junction filters] objectAtIndex:1], nil);
	
	NSPredicate* predicate = [junction createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertNotNil(format, nil);
	
	NSRange range = [format rangeOfString:@"\"Peter\" OR name "];
	GHAssertEquals((NSUInteger)8, range.location, nil);
}


- (void)testConjuction {
	
	CDFilterConjunction* junction = [CDFilter conjuction];
	GHAssertNotNil(junction, nil);
	GHAssertNil(junction.filters, nil);
	
	CDFilter* filter1 = [CDFilter equals:@"name" value:@"Peter"];	
	[junction add:filter1];
	
	CDFilter* filter2 = [CDFilter equals:@"name" value:@"Milan"];	
	[junction add:filter2];
	
	GHAssertEquals((NSUInteger)2, [[junction filters] count], nil);
	GHAssertEquals(filter1, [[junction filters] objectAtIndex:0], nil);
	GHAssertEquals(filter2, [[junction filters] objectAtIndex:1], nil);
	
	NSPredicate* predicate = [junction createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertNotNil(format, nil);
	
	NSRange range = [format rangeOfString:@"\"Peter\" AND name "];
	GHAssertEquals((NSUInteger)8, range.location, nil);	
}

@end
