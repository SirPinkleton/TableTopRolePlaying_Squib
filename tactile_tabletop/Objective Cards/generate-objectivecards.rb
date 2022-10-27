require 'squib'
require 'game_icons'


if ARGV[0].nil?
  data = Squib.csv file: 'CombatObjectiveCards.csv'
else
  data = Squib.csv file: ARGV[0]
end

#grabbing icons from https://game-icons.net/
#using gem game_icons to be able to load them


#width/height/dpi measurements provided by template from BoardGameMaker.com, see poker-size.pdf
Squib::Deck.new(dpi: 300, width: 1050, height: 750, cards: data['Name'].size, layout: 'objectivecardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'safe'
  #rect layout: 'title'
  text str: data['Name'], layout: 'title'
  rect layout: 'lineUnderTitle'
  #rect layout: 'rules'
  text str: data['Challenge'], layout: 'rules'
  #rect layout: 'reward'
  text str: "Reward: ", layout: 'rewardHeader'
  text str: data['Reward'], layout: 'reward'
  
  ## top ability stuff
  #rect layout: 'lineRightOfBubbles'
  #rect layout: 'topTargetBubble'
  #text str: data['Top Ability Target'], layout: 'topTarget'
  #svg data: GameIcons.get('crosshair').recolor(fg: 'aaa', bg: '000', fg_opacity: 0.6, bg_opacity: 0).string, layout: 'topTargetIcon'
  
  
  #rect layout: 'cardNumberCircle'
  #text str: data['ID'], layout: 'cardNumber'

  ## output file stuff

  save_png prefix: 'ttcc_'
  #save_pdf trim: 37.5
end

# Squib::Deck.new(dpi: 300, width: 750, height: 1050, cards: 1, layout: 'charactercardlayout.yml')  do

  # ## overall card stuff

  # background color: 'white'
  # rect layout: 'cut'
  # rect layout: 'backOfCards'
  # svg data: GameIcons.get('rolling-dices').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'diceBack'
  # svg data: GameIcons.get('card-random').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'cardBack'
  # svg data: GameIcons.get('two-coins').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'tokensBack'
  # ## output file stuff

  # save_png prefix: 'ttcc_BACK'
  # #save_pdf trim: 37.5
# end