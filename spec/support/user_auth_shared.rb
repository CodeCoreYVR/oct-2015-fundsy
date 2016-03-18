shared_examples "non authenticated user" do |action|
  it "redirects to the sign in page" do
    eval(action)
    # yield if block_given?
    expect(response).to redirect_to new_session_path
  end
end
