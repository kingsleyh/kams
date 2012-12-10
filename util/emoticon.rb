class Emoticon

  def self.emoticons
    {
        ':)' => 'smile',
        ':(' => 'frown',
        ':D' => 'laugh'
    }
  end

  def self.convert(emoticon)
    emoticons[emoticon]
  end

  def self.reverse(emoticon_text)
    emoticons.each{|k,v| return k if emoticon_text == v}
    nil
  end

  def self.find_first_from(text)
    emoticons.keys.collect{|e| text.scan(e)}.flatten.uniq.collect{|e| convert(e)}.first
  end

  def self.strip_from(phrase)
    emoticons.keys.collect{|e| phrase.scan(e)}.flatten.uniq.collect{|e| convert(e)}.each do |e|
      phrase = phrase.gsub(reverse(e),"").strip
    end
    phrase
  end

end