require 'net/http'
require 'json'
require 'uri'

class ArtiaCriarAtividade
  ENDPOINT = 'https://api.artia.com/graphql'
  TOKEN = '<TOKEN>'
  FOLDER_ID = '<FOLDER_ID>'
  ACCOUNT_ID = '<ACCOUNT_ID>'
  ORGANIZATION_ID = '<ORGANIZATION_ID>'

  def request
    uri = URI(ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    headers = { 'Content-Type' => 'application/json' }

    query = {
      query: <<~GRAPHQL,
        query{
          listingActivities(
              folderId: #{FOLDER_ID},
              accountId: #{ACCOUNT_ID}
          ) {
              id,
              communityId,
              customStatus {
                  id, 
                  statusName,
                  status
              },
              status,
              title,
              description,
              estimatedStart,
              estimatedEnd,
              createdAt,
              updatedAt,
              createdById,
              createdForUser,
              responsible {
                  id,
                  name,
                  email
              },
              parent {
                  id,
                  name,
              }
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
      token = body.dig('data', 'listingActivities')
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

acao = ArtiaCriarAtividade.new
dados = acao.request
puts "Dados final: #{dados}" if dados