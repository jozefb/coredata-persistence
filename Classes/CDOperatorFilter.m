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

#import "CDOperatorFilter.h"

@interface CDOperatorFilter ()

@end


@implementation CDOperatorFilter

@synthesize operatorType;

-(id)initWithPropertyAndValue:(NSString*)aProperty value:(id)aValue operatorType:(CDFilterOperatorType)aOperator {
	if (self = [super initWithPropertyAndValue:aProperty value:aValue]) {
		operatorType = aOperator;
	}
	
	return self;
}

-(NSPredicate*)createPredicate {
	NSMutableString* fmt = [NSMutableString stringWithCapacity:([super.property length] + [[self operatorString] length] + 10)];
	[fmt appendString:@"%K "];
	[fmt appendString:[self operatorString]];
	[fmt appendString:@" %@"];
	NSPredicate* predicate = [NSPredicate predicateWithFormat:fmt, super.property, [super.bindValues objectAtIndex:0]];
	return  predicate;
}
							  
-(NSString*)operatorString {
	NSString* result = nil;
	switch (self.operatorType) {
		case CDFilterOperatorEqual:
			result = @"=";
			break;
		case CDFilterOperatorNotEqual:
			result = @"!=";
			break;
		case CDFilterOperatorGreather:
			result = @">";
			break;
		case CDFilterOperatorLess:
			result = @"<";
			break;
		case CDFilterOperatorLessOrEqual:
			result = @"<=";
			break;
		case CDFilterOperatorGreatherOrEqual:
			result = @">";
			break;
		case CDFilterOperatorLike:
			result = @"like";
			break;
		case CDFilterOperatorIn:
			result = @"in";
			break;
		default:
			result = @"=";
			break;
	}
	
	return result;
}

@end
