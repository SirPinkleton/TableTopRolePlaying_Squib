require 'squib'
require 'game_icons'

if ARGV[0].nil?
  data = Squib.csv file: 'Tactile_Tabletop_Data-Armors.csv'
else
  data = Squib.csv file: ARGV[0]
end
#grabbing icons from https://game-icons.net/
#using gem game_icons to be able to load them


#width/height/dpi measurements provided by template from BoardGameMaker.com, see poker-size.pdf
#45mm is equivalent to 530px
Squib::Deck.new(dpi: 300, width: '45mm', height: '45mm', cards: data['Armor Name'].size, layout: 'armorcardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'safe'
  
  ## top ability stuff
  #rect layout: 'ArmorTitle'
  text str: data['Armor Name'], layout: 'ArmorTitle'
  #rect layout: 'ArmorAbility'
  text str: data['Set Ability 1'], layout: 'ArmorAbility'

  # ## output file stuff

  save_png prefix: 'ttac_'
  #save_pdf trim: 37.5
  save_sheet prefix: 'armor_sprue_', sprue: 'letter_poker_card_armors.yml'
end

Squib::Deck.new(dpi: 300, width: 530, height: 530, cards: data['Armor Name'].size, layout: 'armorcardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'backOfCards'
  svg data: GameIcons.get('swords-emblem').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'emblemBack'
  ## output file stuff

  save_png prefix: 'ttac_BACK'
  #save_pdf trim: 37.5
  save_sheet prefix: 'armor_back_sprue_', sprue: 'letter_poker_card_armors.yml'
end