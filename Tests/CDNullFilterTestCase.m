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
#import "CDLikeFilter.h"
#import "CDNullFilter.h"

@interface CDNullFilterTestCase : GHTestCase {
	
}

@end

@implementation CDNullFilterTestCase

- (BOOL)shouldRunOnMainThread { return YES; }

- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testIsNull {	
	CDNullFilter* filter = (CDNullFilter*)[CDFilter isNull:@"prop"];	
	GHAssertEquals(@"prop", filter.property, nil);
	GHAssertEquals(YES, [filter isNull], nil);
	
	NSPredicate* predicate = [filter createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertNotNil(format, nil);
	
	NSRange range = [format rangeOfString:@"prop == nil"];
	GHAssertEquals((NSUInteger)0, range.location, nil);
}

- (void)testIsNotNull {	
	CDNullFilter* filter = (CDNullFilter*)[CDFilter isNotNull:@"prop"];	
	GHAssertEquals(@"prop", filter.property, nil);
	GHAssertEquals(NO, [filter isNull], nil);
	
	NSPredicate* predicate = [filter createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertNotNil(format, nil);
	
	NSRange range = [format rangeOfString:@"prop != nil"];
	GHAssertEquals((NSUInteger)0, range.location, nil);
}

@end
