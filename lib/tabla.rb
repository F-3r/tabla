class Tabla
  include Enumerable

  attr_reader :data, :fields, :mapper

  class << self
    attr_accessor :separator
  end

  self.separator ||= "|"

  def self.dump(hashes)
    lines = [hashes.first.keys.join(" #{Tabla.separator} ")]
    lines += hashes.map { |i| i.values.join " #{Tabla.separator} " }
    lines.join("\n") << "\n"
  end

  def self.load(string)
    new(string).parse
  end

  def self.load_file(path)
    load File.read path
  end

  def initialize(data)
    @lines = data.split("\n")
    @fields = split @lines.shift
  end

  def parse
    @data = @lines.map do |line|
      fields.zip(split(line)).to_h
    end
  end

  def each(&block)
    return enum_for(:each) unless block_given?
    data.each(&block)
  end

  private

  def split(line)
    line.split(self.class.separator).map(&:strip)
  end
end
