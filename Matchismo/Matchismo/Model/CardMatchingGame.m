//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ricky Blaha on 1/1/14.
//  Copyright (c) 2014 Ricky Blaha. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastChoosePoints;
@property (nonatomic, readwrite) NSMutableArray *lastChooseCards;

@property (strong, nonatomic) NSMutableArray *cards; //of Card

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    
    return _cards;
}

- (instancetype)initWithCardCount:(NSInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? [self.cards objectAtIndex:index] : nil;
}


@synthesize matchCount = _matchCount;

- (NSUInteger) matchCount
{
    if (!_matchCount) _matchCount = 2;
    
    return _matchCount;
}

- (void) setMatchCount:(NSUInteger)matchCount
{
    if (matchCount > 1) _matchCount = matchCount;
}


static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        //find other chosen, un-matched cards
        NSMutableArray *otherChosenCards = [[NSMutableArray alloc] init];
        
        self.lastChoosePoints = 0;
        
        for (Card * otherCard in self.cards) {
            if (otherCard != card && otherCard.isChosen && !otherCard.isMatched) {
                [otherChosenCards addObject:otherCard];
            }
            
            //get score for this match
            if (otherChosenCards.count == self.matchCount - 1) {
                int matchScore = [card match:otherChosenCards];
                
                if (matchScore) {
                    self.lastChoosePoints = matchScore * MATCH_BONUS;
                    self.score += self.lastChoosePoints;
                    
                    card.matched = YES;
                    
                    for (Card * otherCard in otherChosenCards) {
                        otherCard.matched = YES;
                    }
                    
                } else {
                    self.lastChoosePoints = -1 * MISMATCH_PENALTY;
                    self.score += self.lastChoosePoints;
                    
                    for (Card * otherCard in otherChosenCards) {
                        otherCard.chosen = NO;
                    }
                }
                break;
            }
        }
        
        self.score -= COST_TO_CHOOSE;
        card.chosen = YES;
        
        [otherChosenCards addObject:card];
        
        self.lastChooseCards = otherChosenCards;
    }
}

@end



































