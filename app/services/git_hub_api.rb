require './app/poros/commit'
require './app/poros/contributor'
require './app/poros/repo'

class GitHubApi
  attr_reader :commits, :contributors

  def initialize
    @conn = connect
    @commits = commits
    @contributors = contributors
  end

  def connect
    Faraday.new(url: 'https://api.github.com')
  end

  def pull_requests
    response = @conn.get('/repos/mbrandt00/little-esty-shop/pulls?state=closed&per_page=100')
    github = JSON.parse(response.body, symbolize_names: true)
  end

  def contributors
    response = @conn.get('/repos/mbrandt00/little-esty-shop/contributors')
    github = JSON.parse(response.body, symbolize_names: true)
    github.map do |contributor|
      Contributor.new(contributor)
    end
  end

  def commits
    response = @conn.get('/repos/mbrandt00/little-esty-shop/commits?per_page=100')
    github = JSON.parse(response.body, symbolize_names: true)
    github.map do |commit|
      Commit.new(commit)
    end
  end

  def commit_count
    count_hash = Hash.new(0)
    @commits.each do |commit|
      count_hash[commit.username] += 1
    end
    count_hash
  end

  def repo
    response = @conn.get('users/mbrandt00/repos?per_page=100')
    github = JSON.parse(response.body, symbolize_names: true)
    repos = github.map do |repo|
      Repo.new(repo)
    end
    repos.find { |repo| repo.name == 'mbrandt00/little-esty-shop' }
  end
end
