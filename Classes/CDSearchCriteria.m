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

#import <CoreData/CoreData.h>
#import "CDSearchCriteria.h"
#import "CDOrder.h"
#import "CDFilter.h"
#import "CDProjection.h"


@implementation CDSearchCriteria

@synthesize orders=_orders;
@synthesize filters=_filters;
@synthesize entityName;
@synthesize projections=_projections;
@synthesize readPropertyValues;
@synthesize interceptor;

- (void)registerInterceptor:(id <CDQueryTransformInterceptor>) anInterceptor {
	interceptor = anInterceptor;
}

-(void)addOrder:(CDOrder*)order {
	if (_orders == nil) {
		_orders = [[NSMutableArray alloc] init];
	}
	
	[_orders addObject:order];
}

-(void)addFilter:(CDFilter*)filter{
	if (_filters == nil) {
		_filters = [[NSMutableArray alloc] init];
	}
	
	[_filters addObject:filter];
}

-(void)addProjection:(CDProjection*)projection {
	if (_projections == nil) {
		_projections = [[NSMutableArray alloc] init];
	}
	
	[_projections addObject:projection];
}

+ (CDSearchCriteria*) criteria {
	CDSearchCriteria* criteria = [[CDSearchCriteria alloc] init];
	return [criteria autorelease];
}

+(CDSearchCriteria*) criteriaWithEntityName:(NSString*)entityName {
	CDSearchCriteria* criteria = [[CDSearchCriteria alloc] initWithEntityName:entityName];
	return [criteria autorelease];
}

-(id) init {	
	if (!(self = [self initWithEntityName:nil])) {
		
	}
		
	return self;
}

-(id) initWithEntityName:(NSString*)theEntityName {
	if (self = [super init]) {
		self.entityName = theEntityName;
	}
	
	return self;
}

-(void)dealloc {
	[_projections release];	 
	[entityName release];
	[_orders release];
	[_filters release];
	[super dealloc];
}

-(void)removeOrder:(CDOrder*)order {
	[_orders removeObject:order];
}

-(void)removeFilter:(CDFilter*)filter {
	[_filters removeObject:filter];
}

-(BOOL)hasOrders {
	return [self.orders count] > 0;
}

-(BOOL)hasFilters {
	return [self.filters count] > 0;
}

-(BOOL)hasProjections {
	return [self.projections count] > 0;
}

-(NSFetchRequest*)createFetchRequest {
	//
	[interceptor beforeCreateFetchRequest:self];
	
	NSFetchRequest* request = [interceptor createFetchRequest];
	[request setIncludesPropertyValues:self.readPropertyValues];
	
	if ([self hasOrders]) {
		NSMutableArray* sorts = [NSMutableArray arrayWithCapacity:[self.orders count]];
		for (CDOrder* order in self.orders) {
			NSSortDescriptor* sort = [order createSortDescriptor];
			[sorts addObject:sort];
		}
		
		[request setSortDescriptors:sorts];
	}
	
	if ([self hasFilters]) {
		NSMutableArray* predicates = [NSMutableArray arrayWithCapacity:[self.filters count]];
		
		for (CDFilter* filter in self.filters) {
			NSPredicate* predicate = [filter createPredicate];
			[predicates addObject:predicate];
		}
		
		NSPredicate* compoudPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
		[request setPredicate:compoudPredicate];
	}
	
	if ([self hasProjections]) {
		// Not whole object graph - only specific properties
		NSMutableArray* projectionsExpression = [NSMutableArray arrayWithCapacity:[self.projections count]];
		NSDictionary *entityProperties = [request.entity propertiesByName];
		
		for (CDProjection *projection in self.projections) {
			[projectionsExpression addObject:[projection createPropertyDescription:entityProperties]];			
		}
		
		[request setIncludesPropertyValues:YES];
		[request setResultType:NSDictionaryResultType];
		[request setPropertiesToFetch:projectionsExpression];
	}
	
	return request;
}



@end
