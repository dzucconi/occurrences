class Array
  # Same as Array.take with the exception that
  # 0 returns the original array
  def truncate(length=0)
    length == 0 ? self : self.take(length)
  end
end