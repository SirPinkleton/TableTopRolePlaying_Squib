#import squib stuff. requires Ruby to be installed, and for 'gem install squib' and 'gem install game_icons'
require 'squib'
#icons are grabbed from https://game-icons.net/
require 'game_icons'

#this file is designed to be given the name of a .csv file to parse
if ARGV[0].nil?
  data = Squib.csv file: 'Tactile_Tabletop_Data-Level_1_CC.csv'
else
  data = Squib.csv file: ARGV[0]
end


##    Overall card design concepts
# Cards have multiple sections: Bleed, Cut, and Safe
# Bleed is the part of the card you expect to be chopped off by manufacturing
# Cut is stuff that might be cut into by machines, and effectively it is a border around the card
# Safe is the contents of the card. this should never be cut by the machine, otherwise you want to get a refund
# 
# Typical card sleeves, and cards in general, use Poker Cards for their dimentions.
# for Poker cards, the dimensions in pixels are: Bleed width of 822 and height of 1122; Cut width of 750 and height of 1050; Safe width of 690 by a height of 990
# using the above dimensions with center horizontal and vertical alignment, you end up with a border of 36 pixels for the bleed, a border of 30 pixels for the cut,
# and everything else in inside is the Safe content
# 
# put another way, the overall width and height is 822 and 1122 respectively.
# putting a 36 pixel buffer on the left and right is 36 * 2 = 72 pixels
# same for top and bottom
# this is what makes the size of the Cut as 750 width (822 - (36*2) = 750) and 1050 height (1122 - (36*2) = 1050)
# same process of taking a 30 pixel border for the cut produces a Safe width of 690 (750 - (30*2) = 690) and height of 990 (1050 - (30*2) = 990)

 
#icons for the bubbles
crosshairImage = "..\\Svg Files\\Character Bubbles\\crosshair.svg"
binocularsImage = "..\\Svg Files\\Character Bubbles\\binoculars.svg"
stopwatchImage = "..\\Svg Files\\Character Bubbles\\stopwatch.svg"
arrowDunkImage = "..\\Svg Files\\Character Bubbles\\arrow-dunk.svg"


#width/height/dpi measurements provided by template from BoardGameMaker.com, see poker-size.pdf included in this directory
#use the below for home printing (no whitespace around cards, leading to fewer cuts)
#Squib::Deck.new(dpi: 300, width: 750, height: 1050, cards: data['Top Ability Name'].size, layout: 'charactercardlayout.yml')  do
#use the following for professionial printing (extra whitespace their machines are accounting for existing)
Squib::Deck.new(dpi: 300, width: 822, height: 1122, cards: data['Top Ability Name'].size, layout: 'charactercardlayout.yml')  do

  ### overall card stuff

  #if the safety margin (cut) is black, need this background to be white in order to see it
  background color: 'red'
  #This rect call will give the card a black border, of the size of a poker card after it's cut
  rect layout: 'cut'

  
  ## debug
  
  #the rectangle border where the poker card should be guaranteed to not be cut (see poker-size.pdf)
  #not actually useful to be displayed unless debugging, but lots of other items are based off of where the safe edges are
  #rect layout: 'safe'

  ## Creating Backgrounds
  
  #this is the background color for the top ability
  rect layout: 'topAbilityColorBox'
  #just makes the bottom edge with the horizontal bar look a bit cleaner (not rounded, unlike the top)
  rect layout: 'topAbilityColorBoxBorderCover'
  #this is the background color for the bottom ability
  rect layout: 'bottomAbilityColorBox'
  #background color for the passives section, below the bottom ability
  rect layout: 'passivesColorBox'
  #background color for requirements section, below passives
  rect layout: 'requirementsColorBox'
  #again, cleaning up the edges around a box
  rect layout: 'requirementsColorBoxBorderCover'

  ## Top Ability Elements

  #top ability has a few bubbles, summarizing ability data
  #this is the bubble (with a 1 pixel black border, or 'stroke', to stand out) for targets, and it has its own colors
  rect layout: 'topTargetBubble'
  #fill in the bubble with text (has to be concise). Target can be Ally, ENemy, Self, Plant/Animal, area, Target (generic and flexible)
  text str: data['Top Ability Target'], layout: 'topTarget'
  #put in a background image, a little faded, of a crosshair
  svg file: crosshairImage, layout: 'topTargetIcon'

  #similar to above, but for the Range (close, controlled by weapon, controlled by influence)
  rect layout: 'topRangeBubble'
  text str: data['Top Weapon Or Influence'], layout: 'topRange'
  text str: data['Top Ability Target'], layout: 'topTarget'
  svg file: binocularsImage, layout: 'topRangeIcon'

  #similar to above, but for duration (Instant, # rnds, Day,)
  rect layout: 'topDurationBubble'
  text str: data['Top Ability Duration'], layout: 'topDuration'
  svg file: stopwatchImage, layout: 'topDurationIcon'

  #similar to above, but for what happens to the card as a result of using this action (hand, discard, exhaust)
  rect layout: 'topResultBubble'
  text str: data['Top Ability Following Card Action'], layout: 'topResult'
  svg file: arrowDunkImage, layout: 'topResultIcon'

  #now that we've handled bubbles, we need to handle the text of the ability itself
  #these rectangles are good for debugging around resizing, but otherwise shouldn't be made visible
  #rect layout: 'topTitle'
  #rect layout: 'topVariables'
  #rect layout: 'topRules'
  #get the top ability name and put it in the top 'Title' section
  text str: data['Top Ability Name'], layout: 'topTitle'
  #get the shorthand stuff and place it in the 'variables' section (x = level, y = influence, etc.)
  text str: data['Top Ability Die Roll/Scaler'], layout: 'topVariables'
  #get the explanation for the ability and put it in the 'rules' section
  text str: data['Top Ability Rules'], layout: 'topRules'

  #create a horizontal line separating the top and bottom abilities
  rect layout: 'lineTopOfBottomAbility'


  ## bottom ability stuff
  #these are the same as the top ability stuff, but based off a higher y value (so are lower on the card)

  #bubbles
  rect layout: 'bottomTargetBubble'
  text str: data['Bottom Ability Target'], layout: 'bottomTarget'
  svg file: crosshairImage, layout: 'bottomTargetIcon'

  rect layout: 'bottomRangeBubble'
  text str: data['Bottom Weapon Or Influence'], layout: 'bottomRange'
  svg file: binocularsImage, layout: 'bottomRangeIcon'

  rect layout: 'bottomDurationBubble'
  text str: data['Bottom Ability Duration'], layout: 'bottomDuration'
  svg file: stopwatchImage, layout: 'bottomDurationIcon'

  rect layout: 'bottomResultBubble'
  text str: data['Bottom Ability Following Card Action'], layout: 'bottomResult'
  svg file: arrowDunkImage, layout: 'bottomResultIcon'

  #ability specifics
  #rect layout: 'bottomTitle'
  #rect layout: 'bottomRules'
  #rect layout: 'bottomVariables'
  text str: data['Bottom Ability Name'], layout: 'bottomTitle'
  text str: data['Bottom Ability Die Roll/Scaler'], layout: 'bottomVariables'
  text str: data['Bottom Ability Rules'], layout: 'bottomRules'

  ## passives stuff
  #similar to abilities section but for passives

  #create a horizontal line separating the bottom ability and passives section
  rect layout: 'lineTopOfPassives'

  #rect layout: 'passivesTitle'
  #rect layout: 'passivesBody'
  text str: "Passive", layout: 'passivesTitle'
  #passives body is usually 2 level points
  text str: data['Passives'], layout: 'passivesBody'

  ## Tier stuff

  #add a vertical line to the right of the Passives section, where this tier stuff wil be
  rect layout: 'verticalLine'
  #rect layout: 'tierTitle'
  #rect layout: 'tierBody'
  #type of card is often a tier, where tier is a shorthand for how many stat points are 
  #required, indicates how powerful they are
  #alternatively can be objective or Feature cards
  #rect layout: 'typeOfCard'
  text str: data['Type Of Card'], layout: 'typeOfCard'

  ## requirements stuff

  #add a horizontal line to separate passives and requirements
  rect layout: 'lineTopOfRequirements'

  #rect layout: 'requirementsTitle'
  #rect layout: 'requirementsBody1'
  text str: "Requirements", layout: 'requirementsTitle'
  
  #the stat requirements

  statRequirementsText = data['Stat Requirements'].map {|val| val.to_s + ' Stats'}
  statRequirementsTextLayout = 'requirementsBody1'
  #print the text
  text str: statRequirementsText, layout: statRequirementsTextLayout
        
  #repeat if other additional requirements are present
  additionalRequirementsText = data['Additional Requirements'].map {|val| val != "n/a" ? 'Additional: ' + val.to_s : ""}  
  additionalRequirementsTextLayout = 'requirementsBody2'
  text str: additionalRequirementsText, layout: additionalRequirementsTextLayout
  

  #to keep track of cards in a tier, we create a circle and put in a number of its index from the .csv
  #the specific number holds no meaning, we can later swap the order of cards if we need to, right now it's jus the order that it is in the .csv
  rect layout: 'cardNumberCircle'
  text str: data['ID'], layout: 'cardNumber'
  
  
  
  #uncomment this if you want to see how various angle values are treated
  #rect x: 200, y: 200, height: 50, width: 200, fill_color: '#ffffff', angle: 0
  #rect x: 200, y: 200, height: 50, width: 200, fill_color: '#eeeeee', angle: -1
  #rect x: 200, y: 200, height: 50, width: 200, fill_color: '#dddddd', angle: -2
  #rect x: 200, y: 200, height: 50, width: 200, fill_color: '#cccccc', angle: -2.1
  #rect x: 200, y: 200, height: 50, width: 200, fill_color: '#bbbbbb', angle: -2.2
  #rect x: 200, y: 200, height: 50, width: 200, fill_color: '#aaaaaa', angle: -2.3
  #rect x: 200, y: 200, height: 50, width: 200, fill_color: '#999999', angle: -2.4
  #rect x: 210, y: 200, height: 50, width: 200, fill_color: '#888888', angle: -2.5
  #rect x: 215, y: 200, height: 50, width: 200, fill_color: '#777700', angle: -2.6
  #rect x: 200, y: 200, height: 50, width: 200, fill_color: '#666666', angle: -2.7
  #rect x: 220, y: 200, height: 50, width: 200, fill_color: '#555555', angle: 10
  #rect x: 225, y: 200, height: 50, width: 200, fill_color: '#005555', angle: -2.55
  
  

  ## output file stuff
  
  #save each individual card: good for review and professional printing
  save_png prefix: 'ttcc_'
  #save a sheet of cards all together: good for home printing
  #save_sheet sprue: 'letter_poker_card_custom.yml'
end

#this is for creading the back of the card
#use the below for home printing
#Squib::Deck.new(dpi: 300, width: 750, height: 1050, cards: 1, layout: 'charactercardlayout.yml')  do
#use the following for professionial printing
Squib::Deck.new(dpi: 300, width: 822, height: 1122, cards: data['Top Ability Name'].size, layout: 'charactercardlayout.yml')  do

  ## overall card stuff

  #keeping these for reconstructing in future, but it was easier/prettier to have a png include the bleed/cut stuff
  #background color: 'white'
  #rect layout: 'cut'
  
  #background. either a color, or an image
  #if a value in a cell is only an integer then the comparison needs to be with #'s, otherwise it's a string compare
  levelImage = data['Tier'].map {|tier|
      tier == 2 ? "tier-2-back.png" : tier == 3 ? "tier-3-back.png" : "tier-1-back.png"
    }
  png file: levelImage
    
  svg file: "..\\Svg Files\\Backs\\rolling-dices.svg", layout: 'diceBack'
  svg file: "..\\Svg Files\\Backs\\card-random.svg", layout: 'cardBack'
  svg file: "..\\Svg Files\\Backs\\two-coins.svg", layout: 'tokensBack'
  
  text str: "Tactile Tabletop", layout: 'companyLogo'
  #rect layout: 'companyLogo'

  ## output file stuff

  save_png prefix: 'ttcc_BACK'
  #save_pdf trim: 37.5
end