require 'squib'
require 'game_icons'

data = Squib.csv file: 'Tactile Tabletop Data - Armor.csv'
#grabbing icons from https://game-icons.net/
#using gem game_icons to be able to load them


#width/height/dpi measurements provided by template from BoardGameMaker.com, see poker-size.pdf
Squib::Deck.new(dpi: 300, width: 820, height: 820, cards: data['Armor Name'].size, layout: 'armorcardlayout.yml')  do

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

  save_png prefix: 'ttwc_'
  #save_pdf trim: 37.5
end

Squib::Deck.new(dpi: 300, width: 820, height: 820, cards: 1, layout: 'armorcardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'backOfCards'
  svg data: GameIcons.get('swords-emblem').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'emblemBack'
  ## output file stuff

  save_png prefix: 'ttwc_BACK'
  #save_pdf trim: 37.5
end