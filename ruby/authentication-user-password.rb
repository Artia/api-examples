require 'net/http'
require 'json'
require 'uri'

class ArtiaGerarToken
  ENDPOINT = 'https://api.artia.com/graphql'
  EMAIL = '<EMAIL_USER>'
  PASSWORD = '<PASSWORD>'

  def token
    uri = URI(ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    headers = { 'Content-Type' => 'application/json' }

    query = {
      query: <<~GRAPHQL,
        mutation {
          authenticationByEmail(
            email: "#{EMAIL}",
            password: "#{PASSWORD}"
          ) {
            token
          }
        }
      GRAPHQL
      variables: {}
    }

    request = Net::HTTP::Post.new(uri.path, headers)
    request.body = query.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      token = body.dig('data', 'authenticationByEmail', 'token')
      token
    else
      puts "Erro na requisição: #{response.code} - #{response.message}"
      nil
    end
  rescue => e
    puts "Erro inesperado: #{e.message}"
    nil
  end
end

gerador = ArtiaGerarToken.new
token = gerador.token
puts "Token final: #{token}" if token