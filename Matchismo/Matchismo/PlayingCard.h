//
//  PlayingCard.h
//  Matchismo
//
//  Created by Ricky Blaha on 12/29/13.
//  Copyright (c) 2013 Ricky Blaha. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *)validSuits;
+(NSUInteger)maxRank;

@end
