class NamedStringIO < StringIO
  attr_accessor :filename

  def initialize(filename, *args)
    super(*args)
    @filename = filename
  end

  def original_filename
    @filename
  end
end
