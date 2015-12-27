# "Rafael Nadal" -> "rafael_nadal"
def convert_player_name_to_lower(text)
  text.downcase.gsub(/\s/, '_')
end

# "rafael_nadal" -> "Rafael Nadal"
def convert_player_name_to_upper(text)
  text.split('_').map(&:capitalize).join(' ')
end
