//
//  LTZeppelinBomb.h
//  LTZeppelinBomb
//
//  Created by Lex Tang on 2/29/12.
//  Copyright (c) 2012 LexTang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTZeppelinBomb : NSObject

+ (LTZeppelinBomb*)theHugest;

- (void)dropABombOnMe:(NSString*)myName
          zeppelinURI:(NSString*)uriString
             isADrill:(BOOL)isADrill;

- (void)reportMyPosition:(id)myPosition;

- (void)confirmMyPosition:(NSData*)myPositionData;

- (void)disposeTheBomb:(NSDictionary*)bomb
               succeed:(void (^)(NSDictionary* bomb))succeedBlock
                failed:(void (^)(NSDictionary* bomb))failedBlock;

- (void)outOfRange:(NSError*)error;

@end
