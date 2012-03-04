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

#import "CDCriteria.h"

@class NSFetchRequest;
@class NSEntityDescription;
@protocol CDQueryTransformInterceptor;

@interface CDSearchCriteria : NSObject <CDCriteria> {

	NSMutableArray* _orders;
	NSMutableArray* _filters;
	NSMutableArray* _projections;
	NSString* entityName;
	BOOL readPropertyValues;
	
	id <CDQueryTransformInterceptor> __unsafe_unretained interceptor;
}

@property (nonatomic, copy) NSString* entityName;

@property (nonatomic, readonly, unsafe_unretained) id <CDQueryTransformInterceptor> interceptor;


// 
+(CDSearchCriteria*) criteria;
+(CDSearchCriteria*) criteriaWithEntityName:(NSString*)entityName;
-(id) init;
-(id) initWithEntityName:(NSString*)entityName;

//
-(BOOL)hasOrders;
-(BOOL)hasFilters;
-(BOOL)hasProjections;

- (void)registerInterceptor:(id <CDQueryTransformInterceptor>) interceptor;

@end

@interface CDSearchCriteria (CoreData)

/**
 * Creates autoreleased fetch request
 */
-(NSFetchRequest*)createFetchRequest;

@end

@protocol CDQueryTransformInterceptor <NSObject>

- (void)beforeCreateFetchRequest:(id<CDCriteria>)criteria;
- (NSFetchRequest*)createFetchRequest;

@end