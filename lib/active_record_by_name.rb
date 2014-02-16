module ActiveRecordByName
  def by_name!(le_name, options={})
    le_name.to_s.strip!
    by_name(le_name).first || create!(options.merge(name: le_name))
  end

  def by_name(le_name)
    where('UPPER(name) = UPPER(?)', le_name)
  end
end