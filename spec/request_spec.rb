require 'spec_helper'

describe '.map_options' do
  it 'should map the query options' do

    client = MockGerry.new
    options = client.map_options(['q=createAccount', 'q=createGroup'])

    expect(options).to eq('q=createAccount&q=createGroup')
  end
end

describe '.get' do
  it 'should request projects as anoymous' do
    stub = stub_get('/projects/', 'projects.json')

    client = MockGerry.new
    client.projects

    expect(stub).to have_been_requested
  end

  it 'should request projects as user with digest auth' do
    username = 'gerry'
    password = 'whoop'

    body = get_fixture('projects.json')
    
    stub = stub_request(:get, "http://localhost/a/projects/").
      with(:headers => {'Accept'=>'application/json'}).
        to_return(:status => 200, :body => body, :headers => {})

    client = Gerry.new(MockGerry::URL, username, password)
    projects = client.projects

    expect(stub).to have_been_requested

    expect(projects['awesome']['description']).to eq('Awesome project')
    expect(projects['clean']['description']).to eq('Clean code!')
  end

  it 'should request projects as user with basic auth' do
    username = 'gerry'
    password = 'whoop'

    body = get_fixture('projects.json')

    stub = stub_request(:get, "http://localhost/a/projects/").
      with(:headers => {'Accept'=>'application/json'},
           :basic_auth => [username, password]).
        to_return(:status => 200, :body => body, :headers => {})

    client = Gerry.new(MockGerry::URL, username, password)
    client.set_auth_type(:basic_auth)
    projects = client.projects

    expect(stub).to have_been_requested

    expect(projects['awesome']['description']).to eq('Awesome project')
    expect(projects['clean']['description']).to eq('Clean code!')
  end
end
