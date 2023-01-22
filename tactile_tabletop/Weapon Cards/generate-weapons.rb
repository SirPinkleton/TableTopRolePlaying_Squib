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
Squib::Deck.new(dpi: 300, width: '46.7mm', height: '46.7mm', cards: data['Weapon Name'].size, layout: 'weaponcardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'safe'
  
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
  
  text str: "Notes:", layout: 'NotesTitle'
  #rect layout: 'NotesTitle'
  text str: data['Extra Notes'], layout: 'NotesValue'
  #rect layout: 'NotesValue'

  # ## output file stuff

  save_png prefix: 'ttwc_'
  #save_pdf trim: 37.5
  save_sheet prefix: 'weapon_sprue_', sprue: 'letter_poker_card_weapons.yml'

end

Squib::Deck.new(dpi: 300, width: 820, height: 820, cards: data['Weapon Name'].size, layout: 'weaponcardlayout.yml')  do

  ## overall card stuff

  background color: 'white'
  rect layout: 'cut'
  rect layout: 'backOfCards'
  svg data: GameIcons.get('swords-emblem').recolor(fg: 'fff', bg: '000', fg_opacity: 1, bg_opacity: 0).string, layout: 'emblemBack'
  ## output file stuff

  #save_png prefix: 'ttwc_BACK'
  #save_pdf trim: 37.5
  save_sheet prefix: 'weapon_back_sprue_', sprue: 'letter_poker_card_weapons.yml'
end