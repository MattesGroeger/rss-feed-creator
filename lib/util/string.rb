class String
  # Replace variables defined as {{var}} with value of hash[:var]
  def replace_vars(hash)
    self.gsub(/({{([^}]+)}})/) { |m| hash[$2.to_sym] }
  end
end
