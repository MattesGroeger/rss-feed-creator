require_relative '../lib/util/string.rb'

describe String do

  it "should replace vars" do
    expect("foo {{id}}".replace_vars({id: "bar"})).to eq("foo bar")
    expect("foo {{id}} {{test}}".replace_vars({test: "baz", id: "bar"})).to eq("foo bar baz")
    expect("{{id}}{{id}}".replace_vars({test: "baz", id: "bar"})).to eq("barbar")
  end

end
