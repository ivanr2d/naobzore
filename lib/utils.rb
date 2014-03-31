# encoding: utf-8

module Utils
  def self.translit(text, custom_equal = {})
    equivalent = {
      ' '=>'_',
      'а'=>'a', 
      'б'=>'b', 
      'в'=>'v', 
      'г'=>'g', 
      'д'=>'d', 
      'е'=>'e', 
      'ё'=>'e', 
      'ж'=>'zh',
      'з'=>'z', 
      'и'=>'i', 
      'й'=>'i', 
      'к'=>'k', 
      'л'=>'l', 
      'м'=>'m', 
      'н'=>'n', 
      'о'=>'o',
      'п'=>'p', 
      'р'=>'r', 
      'с'=>'s', 
      'т'=>'t', 
      'у'=>'u', 
      'ф'=>'f', 
      'х'=>'h', 
      'ц'=>'ts',
      'ч'=>'ch', 
      'ш'=>'sh', 
      'щ'=>'sch', 
      'ъ'=>'', 
      'ы'=>'y', 
      'ь'=>'', 
      'э'=>'e', 
      'ю'=>'yu', 
      'я'=>'ya' }
    custom_equal.map{|rus_letter, eng_letter| equivalent[rus_letter] = eng_letter}
    translit_text = ""
    text = text.mb_chars.downcase.strip.normalize
    k = text.mb_chars.size

    k.times do |i|
        c = text.mb_chars[i].to_s
        translit_text << (equivalent[c].nil? ? c : equivalent[c])
    end
    return translit_text
  end

  def self.url_translit text
    translit(text).gsub(/[^\w\d\-_]/, '')
  end
end
