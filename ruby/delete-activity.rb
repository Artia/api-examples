require 'net/http'
require 'json'
require 'uri'

class ArtiaRemoverAtividade
  ENDPOINT = 'https://api.artia.com/graphql'
  TOKEN = '<TOKEN>'
  ID = '<ID>'
  ACCOUNT_ID = '<ACCOUNT_ID>'
  ORGANIZATION_ID = '<ORGANIZATION_ID>'

  def request
    uri = URI(ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    headers = { 'Content-Type' => 'application/json' }

    query = {
      query: <<~GRAPHQL,
        mutation{
          destroyActivities(
              ids: [#{ID}],
              accountId: #{ACCOUNT_ID}
          ) {
              message
          }
      }
      GRAPHQL
      variables: {}
    }

    request = Net::HTTP::Post.new(uri.path, headers)
    request["Authorization"] = "Bearer #{TOKEN}"
    request["OrganizationId"] = "#{ORGANIZATION_ID}"
    request.body = query.to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      token = body.dig('data', 'destroyActivities')
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

acao = ArtiaRemoverAtividade.new
dados = acao.request
puts "Dados final: #{dados}" if dados