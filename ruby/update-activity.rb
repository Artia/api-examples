require 'net/http'
require 'json'
require 'uri'

class ArtiaAtualizarAtividade
  ENDPOINT = 'https://api.artia.com/graphql'
  TOKEN = '<TOKEN>'
  ID = '<ID>'
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
        mutation{
          updateActivity(
              id: #{ID},
              title: "Iniciação da API - primeira parte",
              folderId: #{FOLDER_ID},
              accountId: #{ACCOUNT_ID},
              description: "Iniciação do desenvolvimento da API",
              estimatedStart: "2025-04-01",
              estimatedEnd: "2025-04-28"
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
      token = body.dig('data', 'updateActivity')
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

acao = ArtiaAtualizarAtividade.new
dados = acao.request
puts "Dados final: #{dados}" if dados