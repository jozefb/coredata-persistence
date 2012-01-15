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

#import "CDProjection.h"
#import "CDFunction.h"
#import <CoreData/CoreData.h>

@interface CDFunctionProjection : CDProjection {

@private
	CDFunction* _function;
}

@property (nonatomic, retain) CDFunction* function;
- (id)initWithFunction:(CDFunction*)function;

@end

@implementation CDProjection



+ (CDProjection*)createWithProperty:(NSString*)property {
	CDProjection *projection = [[CDProjection alloc] initWithProperty:property];
	return [projection autorelease];
}

+ (CDProjection*)createWithFunction:(CDFunction*)function {
	CDFunctionProjection *projection = [[CDFunctionProjection alloc] initWithFunction:function];
	return [projection autorelease];
}

- (NSPropertyDescription*)createPropertyDescription:(NSDictionary *)entityProperties {
	return [entityProperties objectForKey:self.property];
}

@end

@implementation CDFunctionProjection

@synthesize function=_function;

- (id)initWithFunction:(CDFunction*)function {
	if (self = [super init]) {
		_function = [function retain];
	}
	
	return self;
}

- (NSPropertyDescription*)createPropertyDescription:(NSDictionary *)entityProperties {
	// Expression for the key path.
	NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:self.function.property];	
	// Expression for func
	NSExpression *funcExpression = [NSExpression expressionForFunction:self.function.name arguments:[NSArray arrayWithObject:keyPathExpression]];
	
	NSExpressionDescription *result = [[NSExpressionDescription alloc] init];
	[result setName:[NSString stringWithFormat:@"%@%@", self.function.name, self.function.property]];
	[result setExpression:funcExpression];
	[result setExpressionResultType:self.function.resultType];
	
	return [result autorelease];
}

-(void)dealloc {
	[_function release];
	[super dealloc];
}

@end
