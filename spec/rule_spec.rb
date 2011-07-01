require 'spec_helper'

describe Rulebook::Rule do
  let(:rule) { Rule.new(/^foobar$/){ "Foobar!" } }
end

