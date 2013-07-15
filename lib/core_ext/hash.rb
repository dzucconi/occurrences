class Hash
  def reverse_merge!(other_hash)
    merge!(other_hash){ |key, left, right| left }
  end
end
