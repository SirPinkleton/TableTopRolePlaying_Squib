require 'squib'
require 'game_icons'

if ARGV[0].nil?
  data = Squib.csv file: 'Tactile_Tabletop_Data-Weapons.csv'
else
  data = Squib.csv file: ARGV[0]
end

#grabbing icons from https://game-icons.net/
#using gem game_icons to be able to load them

#width/height/dpi measurements provided by template from BoardGameMaker.com, see poker-size.pdf
#46.7mm is equivalent to 550 pixels. use whichever is easier to track (sprue sheet uses mm, weapon card layout is pixels)
#use below for home printing
#Squib::Deck.new(dpi: 300, width: '46.7mm', height: '46.7mm', cards: data['Weapon Name'].size, layout: 'weaponcardlayout.yml')  do
#use below for professional printing
Squib::Deck.new(dpi: 300, width: 700, height: 700, cards: data['Weapon Name'].size, layout: 'weaponcardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'safe'
  rect layout: 'thickerCorners'
  
  text str: data['Weapon Name'], layout: 'WeaponTitle'
  #rect layout: 'WeaponTitle'
  
  text str: "Attack:", layout: 'AttackTitle'
  #rect layout: 'AttackTitle'
  svg file: data['Attack Die 1'].map {|t| "#{t.downcase}.svg" }, layout: 'AttackDie1'  
  svg file: data['Attack Die 2'].map {|t| "#{t.downcase}.svg" }, layout: 'AttackDie2'
  
  text str: "Defense:", layout: 'DefenseTitle'
  #rect layout: 'DefenseTitle'
  svg file: data['Defense Die'].map {|t| "#{t.downcase}.svg" }, layout: 'DefenseDie'
  
  text str: "Range:", layout: 'RangeTitle'
  #rect layout: 'RangeTitle'
  text str: data['Range'], layout: 'RangeValue'
  #rect layout: 'RangeValue'
  
  text str: "Requires:", layout: 'RequirementsTitle'
  #rect layout: 'RequirementsTitle'
  svg file: data['Requirement1'].map {|t| "#{t.downcase}.svg" }, layout: 'RequirementsValue1'
  svg file: data['Requirement2'].map {|t| "#{t.downcase}.svg" }, layout: 'RequirementsValue2'
  
  #text str: "Notes:", layout: 'NotesTitle'
  rect layout: 'NotesBar'
  text str: data['Extra Notes'], layout: 'NotesValue'
  #rect layout: 'NotesValue'

  # ## output file stuff

  save_png prefix: 'weapon_'
  #save_pdf trim: 37.5
  save_sheet prefix: 'weapon_sprue_', sprue: 'letter_poker_card_weapons.yml'

end

Squib::Deck.new(dpi: 300, width: 700, height: 700, cards: data['Weapon Name'].size, layout: 'weaponcardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'backOfCards'
  rect layout: 'thickerBackCorners'
  svg data: GameIcons.get('swords-emblem').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'emblemBack'
  ## output file stuff

  save_png prefix: 'weapon_back_'
  #save_pdf trim: 37.5
  save_sheet prefix: 'weapon_back_sprue_', sprue: 'letter_poker_card_weapons.yml'
end