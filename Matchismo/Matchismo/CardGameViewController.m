//
//  ViewController.m
//  Matchismo
//
//  Created by Ricky Blaha on 12/29/13.
//  Copyright (c) 2013 Ricky Blaha. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *resultsTextHistoryStack;

@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchModeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property (weak, nonatomic) IBOutlet UISlider *resultsTextHistorySlider;

@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    //oddly the seg control is part yellow, part blue, so this was the fix found online:
    [self.matchModeSegmentedControl setTintColor:[UIColor clearColor]];
    [self.matchModeSegmentedControl setTintColor:[UIColor yellowColor]];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    
    return _game;
}

- (IBAction)touchRedealButton:(id)sender {
    self.game = nil;
    self.resultsTextHistoryStack = nil;
    
    self.game.matchCount = [self getMatchCountMode];
    
    self.matchModeSegmentedControl.enabled = YES;
    self.matchModeLabel.enabled = YES;
    
    [self updateUI];
    
    [self.resultsLabel setText:@"Tap a card to play again."];
    self.resultsTextHistorySlider.enabled = NO;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)getMatchCountMode
{
    return [[self.matchModeSegmentedControl titleForSegmentAtIndex:[self.matchModeSegmentedControl selectedSegmentIndex]] integerValue];
}

- (NSMutableArray *)resultsTextHistoryStack
{
    if (!_resultsTextHistoryStack) _resultsTextHistoryStack = [[NSMutableArray alloc] init];
    
    return _resultsTextHistoryStack;
}

- (IBAction)touchMatchModeSegmentedControl:(UISegmentedControl *)sender {
    self.game.matchCount = [self getMatchCountMode];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    
    [self.game chooseCardAtIndex:chosenButtonIndex];
    
    [self updateUI];
}

- (IBAction)changeChoiceHistorySlider:(UISlider *)sender {
    self.resultsLabel.text = [self.resultsTextHistoryStack objectAtIndex:sender.value];
    self.resultsLabel.alpha = 0.5;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isMatched;
        
        self.scoreLabel.text  = [NSString stringWithFormat:@"Score: %d", self.game.score];
        
        if (card.isChosen) {
            //disable the match count selection
            self.matchModeSegmentedControl.enabled = NO;
            self.matchModeLabel.enabled = NO;
        }
    }
    
    //update the results label
    NSString *chosenCardLabels = @"";
    
    for (Card *card in self.game.lastChooseCards) {
        chosenCardLabels = [chosenCardLabels stringByAppendingString:[NSString stringWithFormat:@"%@ ", card.contents]];
    }
    
    NSString *resultsText = chosenCardLabels;
    
    if (self.game.lastChoosePoints < 0) {
        resultsText = [NSString stringWithFormat:@"%@don't match! %d point penalty!", chosenCardLabels, self.game.lastChoosePoints * -1];
    } else if (self.game.lastChoosePoints > 0) {
        resultsText = [NSString stringWithFormat:@"Matched %@for %d points.", chosenCardLabels, self.game.lastChoosePoints];
    }
    
    self.resultsLabel.text = resultsText;
    self.resultsLabel.alpha = 1;
    
    //push the results label text onto the results history stack
    [self.resultsTextHistoryStack insertObject:resultsText atIndex:0];
    
    self.resultsTextHistorySlider.minimumValue = 0;
    self.resultsTextHistorySlider.maximumValue = [self.resultsTextHistoryStack count] - 1;
    self.resultsTextHistorySlider.value = 0;
    self.resultsTextHistorySlider.enabled = YES;
}

- (NSString *)titleForCard:(Card *)card
{
    return [card isChosen] ? [card contents] : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:[card isChosen] ? @"cardfront" : @"cardback"];
}

















@end
