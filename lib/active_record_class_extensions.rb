module ActiveRecordClassExtensions
  def by_name!(le_name, options={})
    by_name(le_name).first || create!(options.merge(name: le_name))
  end
end