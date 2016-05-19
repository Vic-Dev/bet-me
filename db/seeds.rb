include FactoryGirl::Syntax::Methods

10.times do
  FactoryGirl.create(:user)
end  

10.times do
  FactoryGirl.create(:challenge)
end