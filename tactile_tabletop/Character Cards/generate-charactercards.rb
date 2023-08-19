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


## requirements indexing
#we need to be able to do conditional programming to build a list of requirements for each card. This has to be done outside of the Deck.new() call

  #We can have multiple stats, and we can't predict the order that we'll see them
  #also, we have graphics we'd like to use for each stat
  #in order to marry icons with text, and not have a huge headache of buffer management, we hard code the different slots where requirements can go, and track when something is nonzero
  
  #for each stat record where it's nonzero
  #example of one of these: [0,1,1,0,0...]
  
  nonZeroPrimary = data['Primary Requirements'].map {|val| val > 0 ? 1 : 0}
  nonZeroSecondary = data['Secondary Requirements'].map {|val| val > 0 ? 1 : 0}
  nonZeroTertiary = data['Tertiary Requirements'].map {|val| val > 0 ? 1 : 0}
  nonZeroKnowledge = data['Knowledge Requirements'].map {|val| val > 0 ? 1 : 0}
  nonZeroStrength = data['Strength Requirements'].map {|val| val > 0 ? 1 : 0}
  nonZeroSpirituality = data['Spirituality Requirements'].map {|val| val > 0 ? 1 : 0}
  nonZeroCharisma = data['Charisma Requirements'].map {|val| val > 0 ? 1 : 0}
  nonZeroCraftmanship = data['Craftmanship Requirements'].map {|val| val > 0 ? 1 : 0}
  #create a zero'd out list of the right size for keeping a running total
  #example: [0,0,0,0,0...]
  recordOfWhereStatsGo = data['Primary Requirements'].map {|val| 0}
  
  #add the things we're going to write to the overall record
  #example: if record of where stats go started as [1,1,3,1,0], and nonZeroPrimary was [0,1,1,0,0], then this produces [1,2,4,1,0]
  recordOfWhereStatsGo = recordOfWhereStatsGo.zip(nonZeroPrimary).map{|x,y| x+y}
  #using these new totals, make sure to only write the non-zero ones for the stat by doing a product
  #example: using earlier example, [1,2,4,1,0] * [0,1,1,0,0] = [0,2,4,0,0]
  primaryWriteLocations = recordOfWhereStatsGo.zip(nonZeroPrimary).map{|x,y| x*y}
  #repeat for following stats
  recordOfWhereStatsGo = recordOfWhereStatsGo.zip(nonZeroSecondary).map{|x,y| x+y}
  secondaryWriteLocations = recordOfWhereStatsGo.zip(nonZeroSecondary).map{|x,y| x*y}
  recordOfWhereStatsGo = recordOfWhereStatsGo.zip(nonZeroTertiary).map{|x,y| x+y}
  tertiaryWriteLocations = recordOfWhereStatsGo.zip(nonZeroTertiary).map{|x,y| x*y}
  recordOfWhereStatsGo = recordOfWhereStatsGo.zip(nonZeroKnowledge).map{|x,y| x+y}
  knowledgeWriteLocations = recordOfWhereStatsGo.zip(nonZeroKnowledge).map{|x,y| x*y}
  recordOfWhereStatsGo = recordOfWhereStatsGo.zip(nonZeroStrength).map{|x,y| x+y}
  strengthWriteLocations = recordOfWhereStatsGo.zip(nonZeroStrength).map{|x,y| x*y}
  recordOfWhereStatsGo = recordOfWhereStatsGo.zip(nonZeroSpirituality).map{|x,y| x+y}
  spiritualityWriteLocations = recordOfWhereStatsGo.zip(nonZeroSpirituality).map{|x,y| x*y}
  recordOfWhereStatsGo = recordOfWhereStatsGo.zip(nonZeroCharisma).map{|x,y| x+y}
  charismaWriteLocations = recordOfWhereStatsGo.zip(nonZeroCharisma).map{|x,y| x*y}
  recordOfWhereStatsGo = recordOfWhereStatsGo.zip(nonZeroCraftmanship).map{|x,y| x+y}
  craftmanshipWriteLocations = recordOfWhereStatsGo.zip(nonZeroCraftmanship).map{|x,y| x*y}
  
  #icons for the requirements
  primaryRequirementsImage = "..\\Svg Files\\Stat Requirements\\primary-skill-needed-icon.svg"
  secondaryRequirementsImage = "..\\Svg Files\\Stat Requirements\\secondary-skill-needed-icon.svg"
  tertiaryRequirementsImage = "..\\Svg Files\\Stat Requirements\\tertiary-skill-needed-icon.svg"
  knowledgeRequirementsImage = "..\\Svg Files\\Stat Requirements\\quaternary-skill-needed-icon.svg"
  strengthRequirementsImage = "..\\Svg Files\\Stat Requirements\\quinary-skill-needed-icon.svg"
  spiritualityRequirementsImage = "..\\Svg Files\\Stat Requirements\\senary-skill-needed-icon.svg"
  charismaRequirementsImage = "..\\Svg Files\\Stat Requirements\\septenary-skill-needed-icon.svg"
  craftmanshipRequirementsImage = "..\\Svg Files\\Stat Requirements\\octonary-skill-needed-icon.svg"
  
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

  ### Constructing Stat Bars
  
  # This approach applies a color to the Cut, to make the stat requirements for higher level cards more easy to spot at a glance
  # how this was done was to create a very wide and stout height, and then apply an angle
  # math is done so that multiple points of a 1 or more stats stack on top of each other, from top to bottom
  #we want these bars to be visible around the border, so we're drawing them before the abilities and other parts of the card
  
  
  #some default values to draw from for painting the stat lines
  #having a skewed angle allows them to cover both sides of the border, and it looks snazzy.
  #angles in squib are weird. the higher the value, the more it rotates in a clockwise rotation
  #the units aren't specified in the documentation. 90 doesn't mean 90 radians; the difference between 9 and 10 is closer to 90 degrees.
  #originally we used a value of 10, discovered with lots of testing. -2.55 is roughly the same orientation, but rotating counter clockwise
  #you're encouraged to try value differences in .1 increments for tweaking, it seems to just take experimenting. See near the end of this Deck.new() call for prototyping angles
  defaultAngle = -2.55
  #the x offset sets where the bar starts horizontally. we could start high and to the left, shooting down and to the right towards the card, or reverse of this. Depends on the angle of the bars.
  #We chose low and to the right, so we'll be shooting left and up.
  #we stumbled into 1000 being a decent value, paired with the angle it makes the bar hit the top of the side of the card
  defaultXOffset = 1000
  #we want these bars to cover multiple parts of the border so its easy to see regardless of how the card is oriented. with the above angle and x value,
  #we need a width somewhere around 2000 in order to cover the distance
  defaultwidth = 2000
  #we want these bars to be otherwise not too high, so that we can stack multiple together. we also want to grow them downwards, so they should be negative
  #-40 was found with yet more tweaking and trying out values
  defaultHeight = -55
  #usually don't want the stroke, the fill_color is sufficient
  defaultStrokeWidth = 0
  #this controls how high or low the bar starts. with this angle, x value, and width, 720 looks good: the right-middle and top left of the card get covered by the first bar, and it grows downward from there
  #also, create it as an array of values aligning with the number of cards for math tricks later
  baseYOffset = data['Primary Requirements'].map {|c| 720}
  #icons also need to be placed along the bar and have a spacing
  baseIconsYOffsets = data['Primary Requirements'].map {|c| 100}
  iconDefaultDistanceApart = 55
  
  # colors of the bars. aligns with the colors in the user manual, but could be anything really
  primaryBorderColor = '#00ffff'
  secondaryBorderColor = '#008000'
  tertiaryBorderColor = '#ffc0cb'
  knowledgeBorderColor = '#0000ff'
  strengthBorderColor = '#ff0000'
  spiritualityBorderColor = '#800080'
  charismaBorderColor = '#ffd700'
  craftmanshipBorderColor = '#ffffff'


  ## Creating Primary bars

  #if this card has no primary, then height offset to use is 0
  #this would mean the bar is not visible (height of 0) and the following bar wouldn't be moved down at all (yoffset of 0)
  #otherwise, this Primary bar is a multiple of defaultHeight from what it is
  primaryToHeightMapping = data['Primary Requirements'].map {|value| value * defaultHeight}

  #since primary is the first stat line, set its offsets = base
  primaryYOffsets = baseYOffset
  #create first stat line, based off of what the primary stat requirement for the card is
  rect x: defaultXOffset,
    y: primaryYOffsets,
    width: defaultwidth,
    height: primaryToHeightMapping,
    angle: defaultAngle,
    fill_color: primaryBorderColor,
    stroke_width: defaultStrokeWidth
    
  #create svg also
  primaryIconYOffsets = baseIconsYOffsets
  primaryBarImageLayout = primaryWriteLocations.map {|val| 'barImage' + val.to_s}
  svg file: primaryRequirementsImage, layout: primaryBarImageLayout, y: primaryIconYOffsets


  ## Creating Secondary bars
  
  #like before, we need to figure out how big this stat bar is
  secondaryToHeightMapping = data['Secondary Requirements'].map {|value| value * defaultHeight}

  #before, we were making the first bar. its y offset was effective 0 (base, unmodified)
  #it's possible this card has both a primary and secondary requirement. This means this secondary card should have an increase y offset
  #which is based off of the heights of the previous bar, primary (so we don't overlap bars)
  #first, the height mappings for the primary bars need to be positive for the formatting to work,
  primaryHeightsPositive = primaryToHeightMapping.map {|element| element*=-1;element}
  #now we need to add these height mappings onto the base
  #we can add these first with a .zip operation, this creates sub arrays with the two arrays value's placed side by side
  #ie: if the base is [570,570,570] and p y offsets are [0,0,30] then a zipped array would look like [ [570,0], [570,0], [570,30] ]
  totalPrimaryOffsetArrays = primaryYOffsets.zip(primaryHeightsPositive)
  #now we just need a new array where each of these sub arrays are summed together, to get the cumulative offsets for each card
  #ie: taking from the above example, we want the result [570,570,600]
  secondaryYOffsets = totalPrimaryOffsetArrays.map {|subArray| subArray.sum}
  #create the secondary stat bar
  rect x: defaultXOffset,
    y: secondaryYOffsets,
    width: defaultwidth,
    height: secondaryToHeightMapping,
    angle: defaultAngle,
    fill_color: secondaryBorderColor,
    stroke_width: defaultStrokeWidth
  
  #need to move the secondary icon down x * 20 pixels below the primary icon (assuming it exists)
  #first, figure out what the primary offsets for each card are  
  offsetsFromPrimaryIcons = data['Primary Requirements'].map {|value| value * iconDefaultDistanceApart}
  #secondary icon locations are the previous icons location + the offsets calculated above
  secondaryIconYOffsets = primaryIconYOffsets.zip(offsetsFromPrimaryIcons).map {|subArray| subArray.sum}
  secondaryBarImageLayout = secondaryWriteLocations.map {|val| 'barImage' + val.to_s}
  svg file: secondaryRequirementsImage, layout: secondaryBarImageLayout, y: secondaryIconYOffsets

  ## Creating Tertiary bars
  
  #same as above, but for tertiary
  tertiaryToHeightMapping = data['Tertiary Requirements'].map {|value| value * defaultHeight}

  secondaryHeightsPositive = secondaryToHeightMapping.map {|element| element*=-1;element}
  totalSecondaryOffsetArrays = secondaryYOffsets.zip(secondaryHeightsPositive)
  tertiaryYOffsets = totalSecondaryOffsetArrays.map {|subArray| subArray.sum}
  rect x: defaultXOffset,
    y: tertiaryYOffsets,
    width: defaultwidth,
    height: tertiaryToHeightMapping,
    angle: defaultAngle,
    fill_color: tertiaryBorderColor,
    stroke_width: defaultStrokeWidth

  offsetsFromSecondaryIcons = data['Secondary Requirements'].map {|value| value * iconDefaultDistanceApart}
  tertiaryIconYOffsets = secondaryIconYOffsets.zip(offsetsFromSecondaryIcons).map {|subArray| subArray.sum}
  tertiaryBarImageLayout = tertiaryWriteLocations.map {|val| 'barImage' + val.to_s}
  svg file: tertiaryRequirementsImage, layout: tertiaryBarImageLayout, y: tertiaryIconYOffsets
  
  ## Creating Knowledge bars
  
  #same as the above, but for knowledge
  knowledgeToHeightMapping = data['Knowledge Requirements'].map {|value| value * defaultHeight}

  tertiaryHeightsPositive = tertiaryToHeightMapping.map {|element| element*=-1;element}
  totalTertiaryOffsetArrays = tertiaryYOffsets.zip(tertiaryHeightsPositive)
  knowledgeYOffsets = totalTertiaryOffsetArrays.map {|subArray| subArray.sum}
  rect x: defaultXOffset,
    y: knowledgeYOffsets,
    width: defaultwidth,
    height: knowledgeToHeightMapping,
    angle: defaultAngle,
    fill_color: knowledgeBorderColor,
    stroke_width: defaultStrokeWidth

  offsetsFromTertiaryIcons = data['Tertiary Requirements'].map {|value| value * iconDefaultDistanceApart}
  knowledgeIconYOffsets = tertiaryIconYOffsets.zip(offsetsFromTertiaryIcons).map {|subArray| subArray.sum}
  knowledgeBarImageLayout = knowledgeWriteLocations.map {|val| 'barImage' + val.to_s}
  svg file: knowledgeRequirementsImage, layout: knowledgeBarImageLayout, y: knowledgeIconYOffsets
  
  ## Creating Strength bars
  
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
    stroke_width: defaultStrokeWidth

  offsetsFromKnowledgeIcons = data['Knowledge Requirements'].map {|value| value * iconDefaultDistanceApart}
  strengthIconYOffsets = knowledgeIconYOffsets.zip(offsetsFromKnowledgeIcons).map {|subArray| subArray.sum}
  strengthBarImageLayout = strengthWriteLocations.map {|val| 'barImage' + val.to_s}
  svg file: strengthRequirementsImage, layout: strengthBarImageLayout, y: strengthIconYOffsets
  
  ## Creating Spirituality bars
  
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
    stroke_width: defaultStrokeWidth

  offsetsFromStrengthIcons = data['Strength Requirements'].map {|value| value * iconDefaultDistanceApart}
  spiritualityIconYOffsets = strengthIconYOffsets.zip(offsetsFromStrengthIcons).map {|subArray| subArray.sum}
  spiritualityBarImageLayout = spiritualityWriteLocations.map {|val| 'barImage' + val.to_s}
  svg file: spiritualityRequirementsImage, layout: spiritualityBarImageLayout, y: spiritualityIconYOffsets
  
  ## Creating Charisma bars
  
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
    stroke_width: defaultStrokeWidth

  offsetsFromSpiritualityIcons = data['Spirituality Requirements'].map {|value| value * iconDefaultDistanceApart}
  charismaIconYOffsets = spiritualityIconYOffsets.zip(offsetsFromSpiritualityIcons).map {|subArray| subArray.sum}
  charismaBarImageLayout = charismaWriteLocations.map {|val| 'barImage' + val.to_s}
  svg file: charismaRequirementsImage, layout: charismaBarImageLayout, y: charismaIconYOffsets
  
  ## Creating Craftmanship bars
  
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
    stroke_width: defaultStrokeWidth

  offsetsFromCharismaIcons = data['Charisma Requirements'].map {|value| value * iconDefaultDistanceApart}
  craftmanshipIconYOffsets = charismaIconYOffsets.zip(offsetsFromCharismaIcons).map {|subArray| subArray.sum}
  craftmanshipBarImageLayout = craftmanshipWriteLocations.map {|val| 'barImage' + val.to_s}
  svg file: craftmanshipRequirementsImage, layout: craftmanshipBarImageLayout, y: craftmanshipIconYOffsets
  
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
  text str: "Tier:", layout: 'tierTitle'
  #tier is a shorthand for how many stat points are required, indicates how powerful they are
  #0 state requirements are tier 1, 4 state requirements are tier 2, and 7 state requirements are tier 3
  text str: data['Tier'], layout: 'tierBody'

  ## requirements stuff

  #add a horizontal line to separate passives and requirements
  rect layout: 'lineTopOfRequirements'

  #rect layout: 'requirementsTitle'
  #rect layout: 'requirementsBody1'
  text str: "Requirements", layout: 'requirementsTitle'

 
  

  
  #create arrays of the same size of the value (if 0 it'll be removed in the following step
  primaryRequirementsText = data['Primary Requirements'].map {|val| val > 0 ? val.to_s : ""}
  #figure out if this text should be placed or not by appending the number (0 = doesn't appear)
  primaryRequirementsTextLayout = primaryWriteLocations.map {|val| 'requirementsBody' + val.to_s}
  #print the text
  text str: primaryRequirementsText, layout: primaryRequirementsTextLayout
  
  #icon to use for primary
  #figure out if this image should be placed or not by appending the number (0 = doesn't appear)
  primaryRequirementsImageLayout = primaryWriteLocations.map {|val| 'requirementsImage' + val.to_s}
  #write the icon
  svg file: primaryRequirementsImage, layout: primaryRequirementsImageLayout
      
  #repeat for other stats
  secondaryRequirementsText = data['Secondary Requirements'].map {|val| val > 0 ? val.to_s : ""}  
  secondaryRequirementsTextLayout = secondaryWriteLocations.map {|val| 'requirementsBody' + val.to_s}
  text str: secondaryRequirementsText, layout: secondaryRequirementsTextLayout
  secondaryRequirementsImageLayout = secondaryWriteLocations.map {|val| 'requirementsImage' + val.to_s}
  svg file: secondaryRequirementsImage, layout: secondaryRequirementsImageLayout
  
  
  tertiaryRequirementsText = data['Tertiary Requirements'].map {|val| val > 0 ? val.to_s : ""}
  tertiaryRequirementsTextLayout = tertiaryWriteLocations.map {|val| 'requirementsBody' + val.to_s}
  text str: tertiaryRequirementsText, layout: tertiaryRequirementsTextLayout
  tertiaryRequirementsImageLayout = tertiaryWriteLocations.map {|val| 'requirementsImage' + val.to_s}
  svg file: tertiaryRequirementsImage, layout: tertiaryRequirementsImageLayout
  
  knowledgeRequirementsText = data['Knowledge Requirements'].map {|val| val > 0 ? val.to_s : ""}
  knowledgeRequirementsTextLayout = knowledgeWriteLocations.map {|val| 'requirementsBody' + val.to_s}
  text str: knowledgeRequirementsText, layout: knowledgeRequirementsTextLayout
  knowledgeRequirementsImageLayout = knowledgeWriteLocations.map {|val| 'requirementsImage' + val.to_s}
  svg file: knowledgeRequirementsImage, layout: knowledgeRequirementsImageLayout
  
  strengthRequirementsText = data['Strength Requirements'].map {|val| val > 0 ? val.to_s : ""}
  strengthRequirementsTextLayout = strengthWriteLocations.map {|val| 'requirementsBody' + val.to_s}
  text str: strengthRequirementsText, layout: strengthRequirementsTextLayout
  strengthRequirementsImageLayout = strengthWriteLocations.map {|val| 'requirementsImage' + val.to_s}
  svg file: strengthRequirementsImage, layout: strengthRequirementsImageLayout
  
  spiritualityRequirementsText = data['Spirituality Requirements'].map {|val| val > 0 ? val.to_s : ""}
  spiritualityRequirementsTextLayout = spiritualityWriteLocations.map {|val| 'requirementsBody' + val.to_s}
  text str: spiritualityRequirementsText, layout: spiritualityRequirementsTextLayout
  spiritualityRequirementsImageLayout = spiritualityWriteLocations.map {|val| 'requirementsImage' + val.to_s}
  svg file: spiritualityRequirementsImage, layout: spiritualityRequirementsImageLayout
  
  charismaRequirementsText = data['Charisma Requirements'].map {|val| val > 0 ? val.to_s : ""}
  charismaRequirementsTextLayout = charismaWriteLocations.map {|val| 'requirementsBody' + val.to_s}
  text str: charismaRequirementsText, layout: charismaRequirementsTextLayout
  charismaRequirementsImageLayout = charismaWriteLocations.map {|val| 'requirementsImage' + val.to_s}
  svg file: charismaRequirementsImage, layout: charismaRequirementsImageLayout
  
  craftmanshipRequirementsText = data['Craftmanship Requirements'].map {|val| val > 0 ? val.to_s : ""}
  craftmanshipRequirementsTextLayout = craftmanshipWriteLocations.map {|val| 'requirementsBody' + val.to_s}
  text str: craftmanshipRequirementsText, layout: craftmanshipRequirementsTextLayout
  craftmanshipRequirementsImageLayout = craftmanshipWriteLocations.map {|val| 'requirementsImage' + val.to_s}
  svg file: craftmanshipRequirementsImage, layout: craftmanshipRequirementsImageLayout
  

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