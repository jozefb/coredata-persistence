//
//  Persistence
//
//  Created by Ing. Jozef Bozek on 29.5.2009.
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

#import "CDFilter.h"
#import "CDFilterFactory.h"

@implementation CDFilter

@synthesize filteredElement=_filteredElement;
@synthesize bindNames=_bindNames;
@synthesize bindValues=_bindValues;

-(id)initWithPropertyAndValue:(NSString*)aProperty value:(id)aValue {
	if (self = [super initWithProperty:aProperty]) {
		if (_bindValues == nil) {
			_bindValues = [[NSMutableArray alloc] initWithCapacity:1];
		}
		
		[_bindValues addObject:aValue];
	}
	
	return self;
}

-(id)initWithProperty:(NSString*)aProperty values:(NSArray*)values {
	if (self = [super initWithProperty:aProperty]) {
		if (_bindValues == nil) {
			_bindValues = [[NSMutableArray alloc] initWithArray:values];
		}
	}
	
	return self;
}

+(CDFilter*)equals:(NSString*)aProperty value:(id)aValue {
	return [CDFilterFactory equals:aProperty value:aValue];
}

+(CDFilter*)like:(NSString*)aProperty value:(NSString*)aValue caseSensitive:(BOOL)caseSensitive {
	return [CDFilterFactory like:aProperty value:aValue caseSensitive:caseSensitive];
}

+(CDFilter*)like:(NSString*)aProperty value:(NSString*)aValue {
	return [CDFilterFactory like:aProperty value:aValue];
}

+(CDFilterDisjunction*)disjunction {
	return [CDFilterFactory disjunction];
}

+(CDFilterConjunction*)conjuction {
	return [CDFilterFactory conjuction];
}

+(CDFilter*)notEquals:(NSString*)aProperty value:(id)aValue {
	return [CDFilterFactory notEquals:aProperty value:aValue];
}

+(CDFilter*)less:(NSString*)aProperty value:(id)aValue {
	return [CDFilterFactory less:aProperty value:aValue];
}

+(CDFilter*)greather:(NSString*)aProperty value:(id)aValue {
	return [CDFilterFactory greather:aProperty value:aValue];
}

//  Creates equals filter
+(CDFilter*)isNull:(NSString*)property {
	return [CDFilterFactory isNull:property];
}

//  Creates equals filter
+(CDFilter*)isNotNull:(NSString*)property {
	return [CDFilterFactory isNotNull:property];
}

+(CDFilter*)inValues:(NSString*)property values:(NSArray*)values {
	return [CDFilterFactory inValues:property values:values];
}

@end

@implementation CDFilter (CoreData)

-(NSPredicate*)createPredicate {
	return nil;
}

@end
