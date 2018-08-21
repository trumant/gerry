require 'spec_helper'

describe 'branches' do
  before(:all) do
    @client = MockGerry.new
  end

  it 'fetchs all branches' do
    stub = stub_get('/projects/foo/branches', 'project_branches.json')

    groups = @client.branches('foo')
    expect(stub).to have_been_requested

    expect(groups.size).to eq(3)
    expect(groups.first.fetch('ref')).to eq('master')
  end

  it 'create branch' do
    body = {
      ref: 'master'
    }
    response = %Q<)]}'
{
  "ref": "/refs/heads/stable",
  "revision": "b43",
  "can_delete": true
}
>
    stub = stub_put('/projects/foo/branches/stable', body, response)
    branch = @client.create_branch('foo', 'master', 'stable')

    expect(stub).to have_been_requested

    expect(branch.fetch('ref')).to eql('/refs/heads/stable')
  end
end
