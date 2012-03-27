//
//  Persistence
//
//  Created by Ing. Jozef Bozek on 27.3.2012.
//
//	Copyright © 2010 bring-it-together s.r.o.. All Rights Reserved.
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
//	THIS SOFTWARE IS PROVIDED BY BRING-IT-TOGETHER S.R.O. "AS IS"
//	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
//	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <GHUnitIOS/GHUnit.h>
#import "CDSearchCriteria.h"
#import "CDAnyFilter.h"
#import "CDOrder.h"
#import "CDFunction.h"
#import "CDFilterFactory.h"

@interface CDAnyFilterTest : GHTestCase {
    
}

@end


@implementation CDAnyFilterTest

- (BOOL)shouldRunOnMainThread { return YES; }

- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testAnyFilter {	
	CDFilter* filter1 = [CDFilter equals:@"prop" value:@"xyz"];
    CDFilter * filter = [CDFilterFactory any:filter1];
	GHAssertEquals(@"prop", filter.property, nil);
	
	NSPredicate* predicate = [filter createPredicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertNotNil(format, nil);
	
	NSRange range = [format rangeOfString:@"ANY prop == \"xyz\""];
	GHAssertEquals((NSUInteger)0, range.location, nil);
}


@end
