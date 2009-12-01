require 'yaml'

module BingoInt
  begin
    print   "Loading BingoInt Token List... "
    LIST    = ::YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/bingo-list.yml'))
    print   " Complete!\n"
    print   "Extracting #{LIST.values.flatten.size} methods... "
    METHODS = LIST.inject({}) {|res, (i, ms)| res.merge(ms.inject({}) {|r, m| r.merge({m.gsub(/[^\s\w]/, '').gsub(/\s+/, '_').downcase=>i})}) }
    print   "Complete!\n"
  rescue StandardError => error_msg
    LIST     = {}
    METEHODS = {}
    print "Incomplete! (see error message below)\n"
    puts "#{'-='*40}-\n\n"
    puts error_msg
    puts "\n#{'-='*40}-\n"
  end
end

class Object
  BingoInt::METHODS.each do |name, value|
    define_method(name) { value }
  end
end

class Integer
  def bingo
    BingoInt::LIST[self]
  end

  def to_bingo(random=false)
    bingo ? (random ? bingo[rand(bingo.size)] : bingo[0] ) : self.to_s 
  end
end
