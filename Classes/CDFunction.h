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

#import "CDCriteriaElement.h"
#import <CoreData/CoreData.h>

@protocol CDFunction <NSObject>

// Function name
@property (nonatomic, readonly) NSString *name;
// Function result type
@property (nonatomic, readonly) NSAttributeType resultType;

@end


@interface CDFunction : CDCriteriaElement <CDFunction> {

@private
	NSString *_name;
	// function result type
	NSAttributeType _resultType;
}

// MIN function for given entity property - with result type
+ (CDFunction*)min:(NSString*)property resultType:(NSAttributeType)resultType;

// MAX function for given entity property - with result type
+ (CDFunction*)max:(NSString*)property resultType:(NSAttributeType)resultType;

// SUM function for given entity property - with result type
+ (CDFunction*)sum:(NSString*)property resultType:(NSAttributeType)resultType;

// LOWER function for given entity property - with result type
+ (CDFunction*)lower:(NSString*)property resultType:(NSAttributeType)resultType;


@end
