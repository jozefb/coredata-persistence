//
//  CDFilterFactory.h
//  Persistence
//
//  Created by Ing. Jozef Bozek on 14.2.2010.
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

@class CDFilter;
@class CDFilterJunction;
@class CDFilterDisjunction;
@class CDFilterConjunction;


@interface CDFilterFactory : NSObject {

}

//  Creates case sensitive like filter
+ (CDFilter*)like:(NSString*)aProperty value:(NSString*)value;
//  Creates case sensitive like filter
+ (CDFilter*)like:(NSString*)aProperty value:(NSString*)value caseSensitive:(BOOL)caseSensitive;
//  Creates equals filter
+ (CDFilter*)equals:(NSString*)aProperty value:(id)value;
//  Creates not equals filter
+ (CDFilter*)notEquals:(NSString*)aProperty value:(id)value;

//  Creates "property < value" filter
+ (CDFilter*)less:(NSString*)aProperty value:(id)value;

//  Creates "property > value" filter
+ (CDFilter*)greather:(NSString*)aProperty value:(id)value;

// Creates logical OR filter for filter chaining
+ (CDFilterDisjunction*)disjunction;

// Creates logical AND filter for filter chaining
+ (CDFilterConjunction*)conjuction;

//  Creates equals filter
+ (CDFilter*)isNull:(NSString*)property;

//  Creates equals filter
+ (CDFilter*)isNotNull:(NSString*)property;

//  Creates "property IN values" filter
+ (CDFilter*)inValues:(NSString*)property values:(NSArray*)values;

@end
