guard :shell do
  watch(/(spec|lib).*\/.+\.rb$/) do |m|
    `rspec spec`
  end
end
