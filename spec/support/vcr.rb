VCR.config do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.stub_with :fakeweb
  #c.ignore_localhost = true
end
