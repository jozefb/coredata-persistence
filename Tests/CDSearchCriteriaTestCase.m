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


#import <CoreData/CoreData.h>
#import "GHUnit.h"
#import "CDSearchCriteria.h"
#import "CDFilter.h"
#import "CDOrder.h"
#import "CDProjection.h"
#import "DAOFactory.h"

@interface CDSearchCriteriaTestCase: GHTestCase <CDQueryTransformInterceptor> {
	
}

@end


@implementation CDSearchCriteriaTestCase

- (BOOL)shouldRunOnMainThread { return YES; }

- (void)setUp {
	[DAOFactory setStorePath:@"test.sqlite"];
}

- (void)tearDown {
}

- (void)beforeCreateFetchRequest:(id<CDCriteria>)criteria {
	
}

- (NSFetchRequest*)createFetchRequest {
	
	NSEntityDescription* entityDescritpion = [NSEntityDescription entityForName:@"TestEntity" inManagedObjectContext:[[DAOFactory factory] managedObjectContext]];
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescritpion];
	return [request autorelease];
}

- (void)testInit {
	CDSearchCriteria* criteria = [[CDSearchCriteria alloc] init];
	GHAssertNotNil(criteria, nil);
	GHAssertNil(criteria.orders, nil);
	GHAssertNil(criteria.filters, nil);
	GHAssertNil(criteria.entityName, nil);
	[criteria release];
}

- (void)testCriteria {
	CDSearchCriteria* criteria = [CDSearchCriteria criteria];
	GHAssertNotNil(criteria, nil);
	GHAssertNil(criteria.orders, nil);
	GHAssertNil(criteria.filters, nil);
	GHAssertNil(criteria.entityName, nil);
	
}

- (void)testInitWithEntityName {
	CDSearchCriteria* criteria = [[CDSearchCriteria alloc] initWithEntityName:[NSString stringWithString:@"testEntity"]];
	GHAssertNotNil(criteria, nil);
	GHAssertNil(criteria.orders, nil);
	GHAssertNil(criteria.filters, nil);
	GHAssertEquals(@"testEntity", criteria.entityName, nil);
	[criteria release];
}

- (void)testCriteriaWithEntityName {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	GHAssertNotNil(criteria, nil);
	GHAssertNil(criteria.orders, nil);
	GHAssertNil(criteria.filters, nil);
	GHAssertEquals(@"testEntity", criteria.entityName, nil);
	
}

- (void)testAddFilter {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	
	CDFilter* filter = [[CDFilter alloc] init];
	[criteria addFilter:filter];
	
	GHAssertNil(criteria.orders, nil);
	GHAssertNotNil(criteria.filters, nil);
	GHAssertEquals((NSUInteger)1, [[criteria filters] count], nil);
	[filter release];
}

- (void)testAddProjection {
	CDSearchCriteria* criteria = [CDSearchCriteria criteria];
	
	CDProjection* projection = [[CDProjection alloc] init];
	[criteria addProjection:projection];
	[projection release];
	GHAssertNil(criteria.orders, nil);
	GHAssertNil(criteria.filters, nil);
	GHAssertNotNil(criteria.projections, nil);
	GHAssertEquals((NSUInteger)1, [[criteria projections] count], nil);
	
}

- (void)testRemoveFilter {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	
	CDFilter* filter = [[CDFilter alloc] init];
	[criteria addFilter:filter];
	[filter release];
	GHAssertEquals((NSUInteger)1, [[criteria filters] count], nil);
	
	[criteria removeFilter:filter];
	GHAssertEquals((NSUInteger)0, [[criteria filters] count], nil);
	
}

- (void)testAddOrder {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	
	CDOrder* order = [[CDOrder alloc] init];
	[criteria addOrder:order];
	[order release];
	
	GHAssertNotNil(criteria.orders, nil);
	GHAssertNil(criteria.filters, nil);
	GHAssertEquals((NSUInteger)1, [[criteria orders] count], nil);
	
}

- (void)testRemoveOrder {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	
	CDOrder* order = [[CDOrder alloc] init];
	[criteria addOrder:order];
	GHAssertEquals((NSUInteger)1, [[criteria orders] count], nil);
	
	[criteria removeOrder:order];
	GHAssertEquals((NSUInteger)0, [[criteria orders] count], nil);
	[order release];
}

- (void)testCreateFetchRequest_Order {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	[criteria registerInterceptor:self];
	
	CDOrder* order = [CDOrder order:kCDOrderDescending property:@"prop"];
	[criteria addOrder:order];
	NSFetchRequest* fr = [criteria createFetchRequest];
	GHAssertNotNil(fr, nil);
	
	NSArray* sortDescriptors = [fr sortDescriptors];
	GHAssertEquals((NSUInteger)1, [sortDescriptors count], nil);
	NSSortDescriptor* descriptor = [sortDescriptors objectAtIndex:0];
	GHAssertEquals(NO, [descriptor ascending], nil);
	GHAssertEquals(@"prop", [descriptor key], nil);
}

- (void)testCreateFetchRequest_Filter {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	[criteria registerInterceptor:self];
	
	CDFilter* filter = [CDFilter equals:@"name" value:@"Name1"];
	[criteria addFilter:filter];
	NSFetchRequest* fr = [criteria createFetchRequest];
	GHAssertNotNil(fr, nil);
	
	NSPredicate* predicate = [fr predicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertTrue([format hasPrefix:@"name"], nil);
	GHAssertTrue([format hasSuffix:@"\"Name1\""], nil);
	
}

- (void)testCreateFetchRequest_FilterLike {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	[criteria registerInterceptor:self];
	
	CDFilter* filter = [CDFilter like:@"name" value:@"Name1"];
	[criteria addFilter:filter];
	NSFetchRequest* fr = [criteria createFetchRequest];
	GHAssertNotNil(fr, nil);
	
	NSPredicate* predicate = [fr predicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertTrue([format hasPrefix:@"name"], nil);
	GHAssertTrue([format hasSuffix:@"\"Name1*\""], nil);
	NSRange rangeLike = [format rangeOfString:@"LIKE"];
	GHAssertEquals((NSUInteger)4, rangeLike.length, nil);
	rangeLike = [format rangeOfString:@"LIKE[]"];
	GHAssertEquals((NSUInteger)0, rangeLike.length, nil);
}

- (void)testCreateFetchRequest_FilterLikeCaseInsensitive {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	[criteria registerInterceptor:self];
	
	CDFilter* filter = [CDFilter like:@"name" value:@"Name1" caseSensitive:NO];
	[criteria addFilter:filter];
	NSFetchRequest* fr = [criteria createFetchRequest];
	GHAssertNotNil(fr, nil);
	
	NSPredicate* predicate = [fr predicate];
	GHAssertNotNil(predicate, nil);
	NSString* format = [predicate predicateFormat];
	GHAssertTrue([format hasPrefix:@"name"], nil);
	GHAssertTrue([format hasSuffix:@"\"Name1*\""], nil);
	NSRange rangeLike = [format rangeOfString:@"LIKE[c]"];
	GHAssertEquals((NSUInteger)7, rangeLike.length, nil);
}

- (void)testReadPropertyValues {
	CDSearchCriteria* criteria = [CDSearchCriteria criteriaWithEntityName:[NSString stringWithString:@"testEntity"]];
	criteria.readPropertyValues = NO;
	GHAssertFalse(criteria.readPropertyValues, nil);
	
	criteria.readPropertyValues = YES;
	GHAssertTrue(criteria.readPropertyValues, nil);
}

- (void)testProjection {
	CDSearchCriteria* criteria = [CDSearchCriteria criteria];
	[criteria registerInterceptor:self];
	
	CDProjection* projection = [[CDProjection alloc] initWithProperty:[NSString stringWithString:@"name"]];
	[criteria addProjection:projection];
	[projection release];
	
	GHAssertNotNil(criteria.projections, nil);
	GHAssertEquals((NSUInteger)1, [[criteria projections] count], nil);
		
	NSFetchRequest *fr = [criteria createFetchRequest];
	GHAssertNotNil(fr, nil);
	
	NSArray *ptf = [fr propertiesToFetch];
	GHAssertEquals((NSUInteger)1, [ptf count], nil);
}

- (void)testProjectionCreateWithProperty {
	CDSearchCriteria* criteria = [CDSearchCriteria criteria];
	[criteria registerInterceptor:self];
	
	CDProjection* projection = [CDProjection createWithProperty:[NSString stringWithString:@"name"]];
	[criteria addProjection:projection];
	
	GHAssertNotNil(criteria.projections, nil);
	GHAssertEquals((NSUInteger)1, [[criteria projections] count], nil);
	
	NSFetchRequest *fr = [criteria createFetchRequest];
	GHAssertNotNil(fr, nil);
	
	NSArray *ptf = [fr propertiesToFetch];
	GHAssertEquals((NSUInteger)1, [ptf count], nil);
}

@end
