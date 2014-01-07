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

#import <GHUnitIOS/GHUnit.h>
#import "DAOFactory.h"
#import "DAOBase.h"
#import "CDFunction.h"
#import "CDProjection.h"
#import "CDFilterFactory.h"
#import "TestEntity.h"
#import "Child.h"
#import "CDFilter.h"

@interface DAOFactoryTestCase : GHTestCase {
	
	TestEntity *object1;
	TestEntity *object2;
}

@end

@implementation DAOFactoryTestCase

- (BOOL)shouldRunOnMainThread { return YES; }

- (void)cleanup {
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	
	NSArray *data = [dao findAll];
    for (NSManagedObject * o in data) {
        [dao deleteObject:o];
    }
    
    DAO *daoChild = [[DAOFactory factory] createDAO:@"Child"];
    data = [daoChild findAll];
    for (NSManagedObject * o in data) {
        [dao deleteObject:o];
    }
    [[DAOFactory factory] save];
}

- (void)setUp {
	
}

- (void)tearDown {
	
}

//! Run before the tests (once per test case)
- (void)setUpClass {
    [self cleanup];
	[DAOFactory setStorePath:@"test.sqlite"]; 
	[DAOFactory setStoreType:NSSQLiteStoreType];
	GHAssertEqualStrings(NSSQLiteStoreType, [DAOFactory storeType], @"Store type error");
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	
	DAO *daoChild = [[DAOFactory factory] createDAO:@"Child"];
	
	object1 = [dao insertNewObject];
	[object1 setName:@"abc"];
	[object1 setIntProperty:[NSNumber numberWithInt:10]];
	NSString *name = [object1 name];
	
	
	Child * child = [daoChild insertNewObject];
	object2 = [dao insertNewObject];
	[object2 setName:@"te2"];
	[object2 setIntProperty:[NSNumber numberWithInt:20]];
	[object2 addChildsObject:child];
	[[DAOFactory factory] save];
}

//! Run after the tests (once per test case)
- (void)tearDownClass {
	[self cleanup];
}

- (void)testFactory {	
	[DAOFactory setStorePath:@"test.sqlite"];
	DAOFactory* factory1 = [DAOFactory factory];
	GHAssertNotNil(factory1, @"Runtime dao can not be nil");
	DAOFactory* factory2 = [DAOFactory factory];
	GHAssertEquals(factory1, factory2, @"Factory must be the same isntatnce");
}

- (void)testNewRuntimeDAO {	
	
	DAO *dao = [[DAOFactory factory] newRuntimeDAO:@"TestEntity"];
	GHAssertNotNil(dao, @"Runtime dao is nil");
	
	DAO *dao2 = [[DAOFactory factory] newRuntimeDAO:@"TestEntity"];
	GHAssertNotEquals(dao, dao2, @"Runtime dao can not be same");
	
}

- (void)testCreateRuntimeDAO {	
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	GHAssertNotNil(dao, @"Runtime dao is nil");
	
	DAO *dao2 = [[DAOFactory factory] createDAO:@"TestEntity"];
	GHAssertNotEquals(dao, dao2, @"Runtime dao can not be same");
	
}

- (void)testFindAll {	
	
	DAO *dao = [[DAOFactory factory] newRuntimeDAO:@"TestEntity"];
	
	NSArray *data = [dao findAll];
	GHAssertNotNil(data, nil);
	
	data = [dao findAll:0 limit:1];
	GHAssertNotNil(data, nil);
	
}

- (void)testFindAllOffsetLimit {	
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	// bug limit and fetch offset does not work
	NSArray *data = [dao findAll:1 limit:-1];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)1, [data count], nil);
	
	data = [dao findAll:0 limit:1];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)1, [data count], nil);
	
	data = [dao findAll:1 limit:2];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)1, [data count], nil);
	
}

- (void)testFindMaxName {	
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	
	NSArray *data = [dao findAll];
	GHAssertNotNil(data, nil);
	GHAssertTrue([data count] > 0, nil);
	
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addProjection:[CDProjection createWithFunction:[CDFunction max:@"intProperty" resultType:NSInteger32AttributeType]]];
	data = [dao findAll:criteria];
	GHAssertNotNil(data, nil);
	GHAssertTrue([data count] > 0, nil);
	NSDictionary *props = [data objectAtIndex:0];
	NSNumber *expected = [NSNumber numberWithInt:20];
	NSNumber *found = [props objectForKey:@"max:intProperty"];
	GHAssertEquals([expected intValue], [found intValue], nil);
	
	
}

- (void)testInValues {	
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	DAO *daoChild = [[DAOFactory factory] createDAO:@"Child"];
	
	NSArray *data = [dao findAll];
	GHAssertNotNil(data, nil);
	GHAssertTrue([data count] > 0, nil);
	
	NSArray *dataChilds = [daoChild findAll];
	GHAssertNotNil(dataChilds, nil);
	GHAssertTrue([dataChilds count] > 0, nil);
	
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addFilter:[CDFilterFactory inValues:@"name" values:[NSArray arrayWithObject:@"abc"]]];
	data = [dao findAll:criteria];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)1, [data count], nil);
	
	
}

- (void)testAnyFilter {	
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	DAO *daoChild = [[DAOFactory factory] createDAO:@"Child"];
	
	NSArray *data = [dao findAll];
	GHAssertNotNil(data, nil);
	GHAssertTrue([data count] > 0, nil);
	
	NSArray *dataChilds = [daoChild findAll];
	GHAssertNotNil(dataChilds, nil);
	GHAssertTrue([dataChilds count] > 0, nil);
	
    CDFilter* filter1 = [CDFilterFactory equals:@"childs.intProperty" value:[NSNumber numberWithInt:0]];
    CDFilter * filter = [CDFilterFactory any:filter1];
	GHAssertEquals(@"childs.intProperty", filter.property, nil);
    
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addFilter:filter];
	data = [dao findAll:criteria];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)1, [data count], nil);
}

- (void)testAllFilter {	
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	DAO *daoChild = [[DAOFactory factory] createDAO:@"Child"];
	
	NSArray *data = [dao findAll];
	GHAssertNotNil(data, nil);
	GHAssertTrue([data count] > 0, nil);
	
	NSArray *dataChilds = [daoChild findAll];
	GHAssertNotNil(dataChilds, nil);
	GHAssertTrue([dataChilds count] > 0, nil);
	
    CDFilter* filter1 = [CDFilterFactory equals:@"childs.intProperty" value:[NSNumber numberWithInt:0]];
    CDFilter * filter = [CDFilterFactory all:filter1];
	GHAssertEquals(@"childs.intProperty", filter.property, nil);
    
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addFilter:filter];
	data = [dao findAll:criteria];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)1, [data count], nil);
}

- (void)testContainsFilter {
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	DAO *daoChild = [[DAOFactory factory] createDAO:@"Child"];
	
	NSArray *data = [dao findAll];
	GHAssertNotNil(data, nil);
	GHAssertTrue([data count] > 0, nil);
	
	NSArray *dataChilds = [daoChild findAll];
	GHAssertNotNil(dataChilds, nil);
	GHAssertTrue([dataChilds count] > 0, nil);
	
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addFilter:[CDFilterFactory contains:@"name" value:@"e"]];
	data = [dao findAll:criteria];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)0, [data count], nil);
	
	
}

- (void)testNotFilter {
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	DAO *daoChild = [[DAOFactory factory] createDAO:@"Child"];
	
	NSArray *data = [dao findAll];
	GHAssertNotNil(data, nil);
	GHAssertTrue([data count] > 0, nil);
	
	NSArray *dataChilds = [daoChild findAll];
	GHAssertNotNil(dataChilds, nil);
	GHAssertTrue([dataChilds count] > 0, nil);
	
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addFilter:[CDFilterFactory not:[CDFilterFactory inValues:@"name" values:[NSArray arrayWithObjects:@"aaa", nil]]]];
	data = [dao findAll:criteria];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)2, [data count], nil);
    
}

- (void)testCountProjection {
	
	DAO *dao = [[DAOFactory factory] createDAO:@"TestEntity"];
	
	NSArray *data = [dao findAll];
	GHAssertNotNil(data, nil);
	GHAssertTrue([data count] > 0, nil);
	
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
    [criteria addProjection:[CDProjection createWithProperty:@"name"]];
	[criteria addProjection:[CDProjection createWithFunction:[CDFunction count:@"childs"]]];
	data = [dao findAll:criteria];
	GHAssertNotNil(data, nil);
	GHAssertEquals((NSUInteger)2, [data count], nil);
	
	
}

@end
