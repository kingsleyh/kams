class Slant

  def self.slants
    {
        '?' => 'ask',
        '!' => 'exclaim',
        '.' => 'say'
    }
  end

  def self.convert(slant)
    slants[slant]
  end

  def self.reverse(slant_text)
    slants.each{|k,v| return k if slant_text == v}
    nil
  end

  def self.find_first_from(text)
    slants.keys.collect{|e| text.scan(e)}.flatten.uniq.collect{|e| convert(e)}.first
  end

  def self.apply_to(phrase,slant_text)
    slant_icon = reverse(slant_text)
    icon = slant_icon.nil? ? "." : slant_icon
    "#{phrase}#{icon}"
  end

end