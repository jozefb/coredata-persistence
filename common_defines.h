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

#ifndef CHECK_LOG_ERROR
#define CHECK_LOG_ERROR(error)\
if (error) {\
LOG_ERROR(error);\
}
#endif

#ifndef LOG_ERROR_AND_EXIT1
#define LOG_ERROR_AND_EXIT1(error)\
NSLog(@"Unresolved error %@, %@", error, [error userInfo]);\
exit(1);
#endif

#ifndef LOG_ERROR
#define LOG_ERROR(error) \
NSDictionary * dict  = [error userInfo];\
NSArray * detailedErrors = [dict objectForKey:NSDetailedErrorsKey];\
if (detailedErrors) { \
	for (NSError * detailedError in detailedErrors) {  \
		NSLog(@"Unresolved error : %@", [detailedError userInfo]);  \
	} \
} else { \
	NSLog(@"Unresolved error %@, %@", error, [error userInfo]);  \
}
#endif
