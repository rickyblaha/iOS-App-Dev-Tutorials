//
//  Card.m
//  CardGame
//
//  Created by Ricky Blaha on 12/27/13.
//  Copyright (c) 2013 Ricky Blaha. All rights reserved.
//

#import "Card.h"

@interface Card()

@end


@implementation Card

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}



@end
