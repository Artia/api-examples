const axios = require('axios');

const ENDPOINT = 'https://api.artia.com/graphql';
const TOKEN = '<TOKEN>';
const ID = '<ID>';
const FOLDER_ID = '<FOLDER_ID>';
const ACCOUNT_ID = '<ACCOUNT_ID>';
const ORGANIZATION_ID = '<ORGANIZATION_ID>';

async function atualizarAtividade() {
  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${TOKEN}`,
    'OrganizationId': ORGANIZATION_ID,
  };

  const query = {
    query: `
      mutation {
        updateActivity(
          id: ${ID},
          title: "Iniciação da API - primeira parte",
          folderId: ${FOLDER_ID},
          accountId: ${ACCOUNT_ID},
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
            name
          }
        }
      }
    `,
    variables: {}
  };

  try {
    const response = await axios.post(ENDPOINT, query, { headers });

    if (response.status === 200) {
      const dados = response.data?.data?.updateActivity;
      console.log("Dados final:", dados);
      return dados;
    } else {
      console.error(`Erro na requisição: ${response.status} - ${response.statusText}`);
      return null;
    }
  } catch (error) {
    console.error("Erro inesperado:", error.message);
    return null;
  }
}

atualizarAtividade();
