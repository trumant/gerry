require 'spec_helper'

describe '.list_groups' do    
  it 'should fetch all groups' do
    stub = stub_get('/groups/', 'groups.json')                     
    
    client = MockGerry.new
    groups = client.groups
    expect(stub).to have_been_requested

    expect(groups.size).to eq(6)
    expect(groups).to include('Project Owners')
  end
end