//
//  Deck.h
//  Matchismo
//
//  Created by Ricky Blaha on 12/29/13.
//  Copyright (c) 2013 Ricky Blaha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
