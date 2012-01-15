//
//  CDFilterFactory.m
//  Persistence
//
//  Created by Ing. Jozef Bozek on 14.2.2010.
//
//  Copyright © 2010 bring-it-together s.r.o.. All Rights Reserved.
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

#import "CDFilterFactory.h"
#import "CDFilter.h"
#import "CDEqualFilter.h"
#import "CDFilterDisjunction.h"
#import "CDFilterConjunction.h"
#import "CDLikeFilter.h"
#import "CDNullFilter.h"

@implementation CDFilterFactory

+(CDFilter*)equals:(NSString*)aProperty value:(id)aValue {
	CDFilter* filter = [[CDEqualFilter alloc] initWithPropertyAndValue:aProperty value:aValue];
	return [filter autorelease];
}

+(CDFilter*)like:(NSString*)aProperty value:(NSString*)aValue caseSensitive:(BOOL)caseSensitive {
	CDLikeFilter* filter = [[CDLikeFilter alloc] initWithPropertyAndValue:aProperty value:aValue];
	filter.caseSensitive = caseSensitive;
	return [filter autorelease];
}

+(CDFilter*)like:(NSString*)aProperty value:(NSString*)aValue {
	CDFilter* filter = [[CDLikeFilter alloc] initWithPropertyAndValue:aProperty value:aValue];
	return [filter autorelease];
}

+(CDFilterDisjunction*)disjunction {
	return [[[CDFilterDisjunction alloc] init] autorelease];
}

+(CDFilterConjunction*)conjuction {
	return [[[CDFilterConjunction alloc] init] autorelease];
}

+(CDFilter*)notEquals:(NSString*)aProperty value:(id)aValue {
	CDFilter* filter = [[CDOperatorFilter alloc] initWithPropertyAndValue:aProperty value:aValue operatorType:CDFilterOperatorNotEqual];
	return [filter autorelease];
}

+(CDFilter*)less:(NSString*)aProperty value:(id)aValue {
	CDFilter* filter = [[CDOperatorFilter alloc] initWithPropertyAndValue:aProperty value:aValue operatorType:CDFilterOperatorLess];
	return [filter autorelease];
}

+(CDFilter*)greather:(NSString*)aProperty value:(id)aValue {
	CDFilter* filter = [[CDOperatorFilter alloc] initWithPropertyAndValue:aProperty value:aValue operatorType:CDFilterOperatorGreather];
	return [filter autorelease];
}

//  Creates equals filter
+(CDFilter*)isNull:(NSString*)property {
	CDNullFilter* filter = [[CDNullFilter alloc] initWithProperty:property];
	filter.isNull = YES;
	return [filter autorelease];
}

//  Creates equals filter
+(CDFilter*)isNotNull:(NSString*)property {
	CDNullFilter* filter = [[CDNullFilter alloc] initWithProperty:property];
	filter.isNull = NO;
	return [filter autorelease];
}

+(CDFilter*)inValues:(NSString*)property values:(NSArray*)values {
	CDFilter* filter = [[CDOperatorFilter alloc] initWithPropertyAndValue:property value:values operatorType:CDFilterOperatorIn];
	return [filter autorelease];
}

@end
