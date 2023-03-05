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




#width/height/dpi measurements provided by template from BoardGameMaker.com, see poker-size.pdf included in this directory
#use the below for home printing (no whitespace around cards, leading to fewer cuts)
#Squib::Deck.new(dpi: 300, width: 750, height: 1050, cards: data['Top Ability Name'].size, layout: 'charactercardlayout.yml')  do
#use the following for professionial printing (extra whitespace their machines are accounting for existing)
Squib::Deck.new(dpi: 300, width: 822, height: 1122, cards: data['Top Ability Name'].size, layout: 'charactercardlayout.yml')  do

  ## overall card stuff

  #if the safety margin (cut) is black, need this background to be white in order to see it
  background color: 'white'
  #the rectangle border where the poker card should be cut (see poker-size.pdf)
  rect layout: 'cut'

  ## 

  #some default values to draw from for painting the stat lines
  #we want these bars to be visible around the border, so we're drawing them before the abilities and other parts of the card
  #we want these bars to cover multiple parts of the border so its easy to see regardless of how the card is oriented, so it has a high width
  defaultwidth = 2000
  #we want these bars to be otherwise not too high, so that we can stack them together. we also want to grow them downwards, so they shoulw be negative
  defaultHeight = -40
  #having a skewed angle allows them to cover both sides of the border, and it looks snazzy
  defaultAngle = 10
  #the x offset sets where the bar starts horizontally, and we want it to be low and to the right, shooting left and up.
  #card width is 750, with an angle, we want to start a little further to the right
  defaultXOffset = 1000
  #this controls how high or low the bar starts. with this angle and x value, 570 looks good
  #also, create it as an array of values aligning with the number of cards for math tricks later
  baseYOffset = data['Perception Requirements'].map {|c| 720}

  perceptionBorderColor = '#00ffff'
  vigorBorderColor = '#008000'
  finesseBorderColor = '#ffc0cb'
  knowledgeBorderColor = '#0000ff'
  strengthBorderColor = '#ff0000'
  spiritualityBorderColor = '#800080'
  charismaBorderColor = '#ffd700'
  craftmanshipBorderColor = '#ffffff'


  #if this card has no perception, then height offset to use is 0
  #this would mean the card is not visible (height of 0) and the following bar wouldn't be moved down at all (yoffset of 0)
  #otherwise, this bar's height is a multiple of 30 from what it is
  perceptionToHeightMapping = data['Perception Requirements'].map {|value| value * defaultHeight}

  #since perception is the first stat line, set its offsets = base
  perceptionYOffsets = baseYOffset
  #create first stat line, based off of what the perception stat requirement for the card is
  rect x: defaultXOffset,
    y: perceptionYOffsets,
    width: defaultwidth,
    height: perceptionToHeightMapping,
    angle: defaultAngle,
    fill_color: perceptionBorderColor,
    stroke_width: 0

  #like before, we need to figure out how big this stat bar is
  vigorToHeightMapping = data['Vigor Requirements'].map {|value| value * defaultHeight}

  #before, we were making the first bar. its y offset was effective 0 (base, unmodified)
  #it's possible this card has both a perception and vigor requirement. This means this vigor card should have an increase y offset
  #which is based off of the heights of the previous bar, perception (so we don't overlap bars)
  #first, the height mappings for the perception bars need to be positive for the formatting to work,
  perceptionHeightsPositive = perceptionToHeightMapping.map {|element| element*=-1;element}
  #now we need to add these height mappings onto the base
  #we can add these first with a .zip operation, this creates sub arrays with the two arrays value's placed side by side
  #ie: if the base is [570,570,570] and p y offsets are [0,0,30] then a zipped array would look like [ [570,0], [570,0], [570,30] ]
  totalPerceptionOffsetArrays = perceptionYOffsets.zip(perceptionHeightsPositive)
  #now we just need a new array where each of these sub arrays are summed together, to get the cumulative offsets for each card
  #ie: taking from the above example, we want the result [570,570,600]
  vigorYOffsets = totalPerceptionOffsetArrays.map {|subArray| subArray.sum}
  #create the vigor stat bar
  rect x: defaultXOffset,
    y: vigorYOffsets,
    width: defaultwidth,
    height: vigorToHeightMapping,
    angle: defaultAngle,
    fill_color: vigorBorderColor,
    stroke_width: 0

  #same as above, but for finesse
  finesseToHeightMapping = data['Finesse Requirements'].map {|value| value * defaultHeight}

  vigorHeightsPositive = vigorToHeightMapping.map {|element| element*=-1;element}
  totalVigorOffsetArrays = vigorYOffsets.zip(vigorHeightsPositive)
  finesseYOffsets = totalVigorOffsetArrays.map {|subArray| subArray.sum}
  rect x: defaultXOffset,
    y: finesseYOffsets,
    width: defaultwidth,
    height: finesseToHeightMapping,
    angle: defaultAngle,
    fill_color: finesseBorderColor,
    stroke_width: 0

  #same as the above, but for knowledge
  knowledgeToHeightMapping = data['Knowledge Requirements'].map {|value| value * defaultHeight}

  finesseHeightsPositive = finesseToHeightMapping.map {|element| element*=-1;element}
  totalFinesseOffsetArrays = finesseYOffsets.zip(finesseHeightsPositive)
  knowledgeYOffsets = totalFinesseOffsetArrays.map {|subArray| subArray.sum}
  rect x: defaultXOffset,
    y: knowledgeYOffsets,
    width: defaultwidth,
    height: knowledgeToHeightMapping,
    angle: defaultAngle,
    fill_color: knowledgeBorderColor,
    stroke_width: 0

  #same as the above, but for strength
  strengthToHeightMapping = data['Strength Requirements'].map {|value| value * defaultHeight}

  knowledgeHeightsPositive = knowledgeToHeightMapping.map {|element| element*=-1;element}
  totalKnowledgeOffsetArrays = knowledgeYOffsets.zip(knowledgeHeightsPositive)
  strengthYOffsets = totalKnowledgeOffsetArrays.map {|subArray| subArray.sum}
  rect x: defaultXOffset,
    y: strengthYOffsets,
    width: defaultwidth,
    height: strengthToHeightMapping,
    angle: defaultAngle,
    fill_color: strengthBorderColor,
    stroke_width: 0

  #same as the above, but for spirituality
  spiritualityToHeightMapping = data['Spirituality Requirements'].map {|value| value * defaultHeight}

  strengthHeightsPositive = strengthToHeightMapping.map {|element| element*=-1;element}
  totalStrengthOffsetArrays = strengthYOffsets.zip(strengthHeightsPositive)
  spiritualityYOffsets = totalStrengthOffsetArrays.map {|subArray| subArray.sum}
  rect x: defaultXOffset,
    y: spiritualityYOffsets,
    width: defaultwidth,
    height: spiritualityToHeightMapping,
    angle: defaultAngle,
    fill_color: spiritualityBorderColor,
    stroke_width: 0

  #same as the above, but for charisma
  charismaToHeightMapping = data['Charisma Requirements'].map {|value| value * defaultHeight}

  spiritualityHeightsPositive = spiritualityToHeightMapping.map {|element| element*=-1;element}
  totalSpiritualityOffsetArrays = spiritualityYOffsets.zip(spiritualityHeightsPositive)
  charismaYOffsets = totalSpiritualityOffsetArrays.map {|subArray| subArray.sum}
  rect x: defaultXOffset,
    y: charismaYOffsets,
    width: defaultwidth,
    height: charismaToHeightMapping,
    angle: defaultAngle,
    fill_color: charismaBorderColor,
    stroke_width: 0

  #same as the above, but for craftmanship
  craftmanshipToHeightMapping = data['Craftmanship Requirements'].map {|value| value * defaultHeight}

  charismaHeightsPositive = charismaToHeightMapping.map {|element| element*=-1;element}
  totalCharismaOffsetArrays = charismaYOffsets.zip(charismaHeightsPositive)
  craftmanshipYOffsets = totalCharismaOffsetArrays.map {|subArray| subArray.sum}
  rect x: defaultXOffset,
    y: craftmanshipYOffsets,
    width: defaultwidth,
    height: craftmanshipToHeightMapping,
    angle: defaultAngle,
    fill_color: craftmanshipBorderColor,
    stroke_width: 0

  #the rectangle border where the poker card should be guaranteed to not be cut (see poker-size.pdf)
  #not actually useful to be displayed unless debugging, but lots of other items are based off of where the safe edges are
  #rect layout: 'safe'

  #this is the background color for the top ability
  rect layout: 'topAbilityColorBox'
  #I think this just makes the bottom edge with the horizontal bar look a bit cleaner
  rect layout: 'topAbilityColorBoxBorderCover'
  #this is the background color for the bottom ability
  rect layout: 'bottomAbilityColorBox'
  #background color for the passives section, below the bottom ability
  rect layout: 'passivesColorBox'
  #background color for requirements section, below passives
  rect layout: 'requirementsColorBox'
  #again, cleaning up the edges around a box
  rect layout: 'requirementsColorBoxBorderCover'

  ## top ability stuff

  #top ability has a few bubbles, summarizing ability data
  #this is the bubble (with a 1 pixel black border, or 'stroke', to stand out) for targets, and it has its own colors
  rect layout: 'topTargetBubble'
  #fill in the bubble with text (has to be concise). Target can be Ally, ENemy, Self, Plant/Animal, area, Target (generic and flexible)
  text str: data['Top Ability Target'], layout: 'topTarget'
  #put in a background image, a little faded, of a crosshair
  svg data: GameIcons.get('crosshair').recolor(fg: 'aaa', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'topTargetIcon'

  #similar to above, but for the Range (close, controlled by weapon, controlled by influence)
  rect layout: 'topRangeBubble'
  text str: data['Top Weapon Or Influence'], layout: 'topRange'
  text str: data['Top Ability Target'], layout: 'topTarget'
  svg data: GameIcons.get('binoculars').recolor(fg: 'aaa', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'topRangeIcon'

  #similar to above, but for duration (Instant, # rnds, Day,)
  rect layout: 'topDurationBubble'
  text str: data['Top Ability Duration'], layout: 'topDuration'
  svg data: GameIcons.get('stopwatch').recolor(fg: 'aaa', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'topDurationIcon'

  #similar to above, but for what happens to the card as a result of using this action (hand, discard, exhaust)
  rect layout: 'topResultBubble'
  text str: data['Top Ability Following Card Action'], layout: 'topResult'
  svg data: GameIcons.get('arrow-dunk').recolor(fg: 'aaa', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'topResultIcon'

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
  svg data: GameIcons.get('crosshair').recolor(fg: '777', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'bottomTargetIcon'

  rect layout: 'bottomRangeBubble'
  text str: data['Bottom Weapon Or Influence'], layout: 'bottomRange'
  svg data: GameIcons.get('binoculars').recolor(fg: 'aaa', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'bottomRangeIcon'

  rect layout: 'bottomDurationBubble'
  text str: data['Bottom Ability Duration'], layout: 'bottomDuration'
  svg data: GameIcons.get('stopwatch').recolor(fg: '777', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'bottomDurationIcon'

  rect layout: 'bottomResultBubble'
  text str: data['Bottom Ability Following Card Action'], layout: 'bottomResult'
  svg data: GameIcons.get('arrow-dunk').recolor(fg: 'aaa', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'bottomResultIcon'

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
  text str: "Tier:", layout: 'tierTitle'
  #tier is a shorthand for how many stat points are required, indicates how powerful they are
  #0 state requirements are tier 1, 4 state requirements are tier 2, and 7 state requirements are tier 3
  text str: data['Tier'], layout: 'tierBody'

  ## requirements stuff

  #add a horizontal line to separate passives and requirements
  rect layout: 'lineTopOfRequirements'

  #rect layout: 'requirementsTitle'
  #rect layout: 'requirementsBody'
  text str: "Requirements", layout: 'requirementsTitle'

  #create empty array of the right size
  requirementsText = data['Perception Requirements'].map {|val| " "}
  #create arrays of the same size, either empty or with the info for their stats specified
  perceptionRequirementsText = data['Perception Requirements'].map {|val| val > 0 ? val.to_s + " Per " : ""}
  vigorRequirementsText = data['Vigor Requirements'].map {|val| val > 0 ? val.to_s + " Vig " : ""}
  finesseRequirementsText = data['Finesse Requirements'].map {|val| val > 0 ? val.to_s + " Fin " : ""}
  knowledgeRequirementsText = data['Knowledge Requirements'].map {|val| val > 0 ? val.to_s + " Kno " : ""}
  strengthRequirementsText = data['Strength Requirements'].map {|val| val > 0 ? val.to_s + " Str " : ""}
  spiritualityRequirementsText = data['Spirituality Requirements'].map {|val| val > 0 ? val.to_s + " Spi " : ""}
  charismaRequirementsText = data['Charisma Requirements'].map {|val| val > 0 ? val.to_s + " Cha " : ""}
  craftmanshipRequirementsText = data['Craftmanship Requirements'].map {|val| val > 0 ? val.to_s + " Cra " : ""}

  #append all the strings together across the arrays
  #zip the arrays together, so each entry becomes a sub array of all the text
  requirementsText = requirementsText.zip(perceptionRequirementsText, vigorRequirementsText, finesseRequirementsText, knowledgeRequirementsText, strengthRequirementsText, spiritualityRequirementsText, charismaRequirementsText, craftmanshipRequirementsText)
  #turn the sub arrays into singular strings
  requirementsText = requirementsText.map {|subArray| subArray * ""}


  #requirements are any number of stat requirements (needing 4 strength, or 2 perception and 2 knowledge, etc.)
  text str: requirementsText, layout: 'requirementsBody'


  #to keep track of cards in a tier, we create a circle and put in a number of its index from the .csv
  #the specific number holds no meaning, we can later swap the order of cards if we need to, right now it's jus the order that it is in the .csv
  rect layout: 'cardNumberCircle'
  text str: data['ID'], layout: 'cardNumber'

  ## output file stuff
  
  #save each individual card: good for review and professional printing
  save_png prefix: 'ttcc_'
  #save a sheet of cards all together: good for home printing
  #save_sheet sprue: 'letter_poker_card_custom.yml'
end

#this is for creading the back of the card, right now a single image
#use the below for home printing, the following for professionial printing
#Squib::Deck.new(dpi: 300, width: 750, height: 1050, cards: 1, layout: 'charactercardlayout.yml')  do
Squib::Deck.new(dpi: 300, width: 822, height: 1122, cards: 1, layout: 'charactercardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'backOfCards'
  svg data: GameIcons.get('rolling-dices').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'diceBack'
  svg data: GameIcons.get('card-random').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'cardBack'
  svg data: GameIcons.get('two-coins').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'tokensBack'
  text str: "Tactile Tabletop", layout: 'companyLogo'
  #rect layout: 'companyLogo'

  ## output file stuff

  save_png prefix: 'ttcc_BACK'
  #save_pdf trim: 37.5
end