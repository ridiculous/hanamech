module ArrayExtensions
  def m(name)
    map(&name.to_sym)
  end
end

Array.send(:include, ArrayExtensions)