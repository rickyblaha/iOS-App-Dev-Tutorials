//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ricky Blaha on 1/1/14.
//  Copyright (c) 2014 Ricky Blaha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype)initWithCardCount:(NSInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic) NSUInteger matchCount;
@property (nonatomic, readonly) NSInteger score;

@property (nonatomic, readonly) NSInteger lastChoosePoints;
@property (nonatomic, readonly) NSMutableArray *lastChooseCards;

@end
