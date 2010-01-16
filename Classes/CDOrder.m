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

#import "CDOrder.h"


@implementation CDOrder

@synthesize orderType;

-(id)initWithPropertyAndType:(NSString*)aProperty orderType:(CDOrderType)aOrderType {
	if (self = [super initWithProperty:aProperty]) {
		orderType = aOrderType;
	}
	
	return self;
}

+(CDOrder*)createWithPropertyAndType:(NSString*)aProperty orderType:(CDOrderType)aOrderType {
	CDOrder* order = [[CDOrder alloc] initWithPropertyAndType:aProperty orderType:aOrderType];
	return [order autorelease];
}

+(CDOrder*)ascendingOrder:(NSString*)aProperty {
	return [CDOrder createWithPropertyAndType:aProperty orderType:kCDOrderAscending];
}

+(CDOrder*)descendingOrder:(NSString*)aProperty {
	return [CDOrder createWithPropertyAndType:aProperty orderType:kCDOrderDescending];
}

+(CDOrder*)order:(CDOrderType)orderType property:(NSString*)aProperty {
	return [CDOrder createWithPropertyAndType:aProperty orderType:orderType];
}


-(void)dealloc {
	[super dealloc];
}

@end

@implementation CDOrder (CoreData) 

-(NSSortDescriptor*)createSortDescriptor {
	NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:super.property ascending:self.orderType];
	[descriptor autorelease];
	return descriptor;
}

@end
