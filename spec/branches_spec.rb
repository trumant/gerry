require 'spec_helper'
require 'pry'

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

  it 'create access rights change for review' do
    access = {
      'user:great' => {
        'action' => 'DENY',
        'force' => false
      }
    }
    response = %Q<)]}'
{
  "id": "xxx",
  "project": "foo",
  "branch": "master",
  "hashtags": [],
  "change_id": "aadd",
  "subject": "review access change",
  "status": "NEW",
  "created": "2017-09-07 12:12:11 .852000000",
  "updated": "2017-09-07 12:12:11 .852000000",
  "submit_type": "CHERRY_PICK",
  "mergable": true,
  "insertions": 2,
  "deletions": 0,
  "unresolved_commnet_count": 0,
  "has_review_started": true,
  "_number": 7,
  "owner": {
    "_account_id": 10000
  }
}
>
    body = {
      'add' => {
        'refs/heads/master' => {
          'permissions' => {
            'read' => {
              'rules' => {
                'user:great' => {
                  'action' => 'DENY',
                  'force' => false
                }
              }
            }
          }
        }
      }
    }

    stub = stub_put('/projects/foo/access', body, response)
    access = @client.create_branch_access('foo', 'master', access)
    expect(stub).to have_been_requested
  end
end
