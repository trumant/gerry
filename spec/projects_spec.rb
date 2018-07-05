require 'spec_helper'
require 'pry'

describe '.projects' do
  before(:all) do
    @client = MockGerry.new
  end

  it 'should fetch all projects' do
    stub = stub_get('/projects/', 'projects.json')

    projects = @client.projects

    expect(stub).to have_been_requested

    expect(projects['awesome']['description']).to eq('Awesome project')
    expect(projects['clean']['description']).to eq('Clean code!')
  end

  it 'should fetch a project' do
    stub = stub_get('/projects/awesome', 'projects.json')

    projects = @client.find_project('awesome')

    expect(stub).to have_been_requested

    expect(projects['awesome']['description']).to eq('Awesome project')
  end

  it 'should resolve the symbolic HEAD ref of a project' do
    project = 'awesome'
    stub = stub_get("/projects/#{project}/HEAD", 'project_head.json')

    branch = @client.get_head(project)

    expect(stub).to have_been_requested

    expect(branch).to eq('refs/heads/stable')
  end

  it 'should define the symbolic HEAD ref of a project' do
    project = 'awesome'
    branch = 'stable'
    input = {
      ref: 'refs/heads/' + branch
    }
    stub = stub_put("/projects/#{project}/HEAD", input.to_json, get_fixture('project_head.json'))

    new_branch = @client.set_head(project, branch)

    expect(stub).to have_been_requested

    expect(new_branch).to eq('refs/heads/' + branch)
  end

  it 'list access rights' do
    stub = stub_get('/projects/foo/access', 'branch_access.json')

    accesses = @client.project_access('foo')
    expect(stub).to have_been_requested
  end
end
