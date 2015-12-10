RSpec::Matchers.define :have_back_button do
  match do |actual|
    actual.has_css? 'button > i.fa-arrow-left'
  end
end
