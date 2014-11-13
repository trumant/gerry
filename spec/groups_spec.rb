require 'spec_helper'

describe '.list_groups' do    
  it 'fetchs all groups' do
    stub = stub_get('/groups/', 'groups.json')                     
    
    client = MockGerry.new
    groups = client.groups
    expect(stub).to have_been_requested

    expect(groups.size).to eq(6)
    expect(groups).to include('Project Owners')
  end
end

describe '.group_members' do
  it "fetchs all members of the specified group" do
    stub = stub_get('/groups/834ec36dd5e0ed21a2ff5d7e2255da082d63bbd7/members/', 'group_members.json')

    client = MockGerry.new
    group_members = client.group_members('834ec36dd5e0ed21a2ff5d7e2255da082d63bbd7')
    expect(stub).to have_been_requested

    expect(group_members.size).to eq(2)
    expect(group_members[1]['email']).to eq('john.doe@example.com')
  end
end