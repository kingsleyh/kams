class TestDataGenerator

  def self.random_alpha(size)
    alphas = ""
    size.times { alphas << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61))).chr }
    alphas
  end

  def self.random_string(size)
    (0...size).map{ ('a'..'z').to_a[rand(26)] }.join
  end

  def self.random_number(size)
    rand(9999999999).to_s.center(size, rand(9).to_s)
  end


end