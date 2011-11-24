describe "competitions" do
  describe "GET index" do
    before :each do
      create(:competition, :name => "Karlsruhe 2011")
      create(:competition, :name => "Aachen Open 2123")
    end

    it "displays competition names" do
      visit competitions_path
      page.should have_content("Karlsruhe 2011")
      page.should have_content("Aachen Open 2123")
    end
  end
end
