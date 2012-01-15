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

#import "CDFunction.h"


@implementation CDFunction

@synthesize name=_name, resultType=_resultType;

-(id)initWithPropertyAndNameAndType:(NSString*)prop name:(NSString*)aName resultType:(NSAttributeType)resultType {
	if (self = [super initWithProperty:prop]) {
		_name = [aName retain];
		_resultType = resultType;
	}
	
	return self;
}

// MIN function for given entity property
+ (CDFunction*)min:(NSString*)property resultType:(NSAttributeType)resultType {
	CDFunction *function = [[CDFunction alloc] initWithPropertyAndNameAndType:property name:@"min:" resultType:resultType];
	return [function autorelease];
}

// MAX function for given entity property
+ (CDFunction*)max:(NSString*)property resultType:(NSAttributeType)resultType {
	CDFunction *function = [[CDFunction alloc] initWithPropertyAndNameAndType:property name:@"max:" resultType:resultType];
	return [function autorelease];
}

// SUM function for given entity property
+ (CDFunction*)sum:(NSString*)property resultType:(NSAttributeType)resultType {
	CDFunction *function = [[CDFunction alloc] initWithPropertyAndNameAndType:property name:@"sum:" resultType:resultType];
	return [function autorelease];
}

// LOWER function for given entity property
+ (CDFunction*)lower:(NSString*)property resultType:(NSAttributeType)resultType {
	CDFunction *function = [[CDFunction alloc] initWithPropertyAndNameAndType:property name:@"lower:" resultType:resultType];
	return [function autorelease];
}



- (void)dealloc {
	[_name release];
	[super dealloc];
}

@end
