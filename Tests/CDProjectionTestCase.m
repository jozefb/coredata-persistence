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
#import <CoreData/CoreData.h>
#import "CDSearchCriteria.h"
#import "CDFilter.h"
#import "CDOrder.h"
#import "CDProjection.h"
#import "CDFunction.h"

@interface CDProjectionTestCase : GHTestCase {
	
}

@end

@implementation CDProjectionTestCase

- (BOOL)shouldRunOnMainThread { return YES; }

- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testCreateWithFunction {
	CDFunction* function = [CDFunction max:@"name" resultType:NSStringAttributeType];
	CDProjection* projection = [CDProjection createWithFunction:function];
	GHAssertNotNil(projection, nil);
	GHAssertNil(projection.property, nil);
	
}

- (void)testCreatePropertyDescription_PropertyProjection {

	CDProjection* projection = [CDProjection createWithProperty:@"name"];
	GHAssertNotNil(projection, nil);
	GHAssertEqualStrings(@"name", projection.property, nil);
	
	NSMutableDictionary * entityProperties = [NSMutableDictionary dictionary];
	NSPropertyDescription *pd = [[NSPropertyDescription alloc] init];
	[entityProperties setValue:pd forKey:@"name"];
	NSPropertyDescription *descr = [projection createPropertyDescription:entityProperties];
	GHAssertNotNil(descr, nil);
	GHAssertTrue(descr == pd, nil);
}

- (void)testCreatePropertyDescription_FunctionProjection {
	CDFunction* function = [CDFunction max:@"name" resultType:NSStringAttributeType];
	CDProjection* projection = [CDProjection createWithFunction:function];
	GHAssertNotNil(projection, nil);
	GHAssertNil(projection.property, nil);
	
	NSMutableDictionary * entityProperties = [NSMutableDictionary dictionary];
	NSPropertyDescription *pd = [[NSPropertyDescription alloc] init];
	[entityProperties setValue:pd forKey:@"name"];
	NSExpressionDescription *descr = (NSExpressionDescription*)[projection createPropertyDescription:entityProperties];
	GHAssertNotNil(descr, nil);
	GHAssertEquals(function.resultType, [descr expressionResultType], nil);
	GHAssertEqualStrings(@"max:name", descr.name, nil);
	
	NSExpression *funcExpression = [descr expression];
	GHAssertNotNil(funcExpression, nil);
	GHAssertEquals((NSExpressionType)NSFunctionExpressionType, [funcExpression expressionType], nil);
}

@end
