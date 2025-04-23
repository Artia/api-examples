const axios = require('axios');

const ENDPOINT = 'https://api.artia.com/graphql';
const TOKEN = '<TOKEN>';
const FOLDER_ID = '<FOLDER_ID>';
const ACCOUNT_ID = '<ACCOUNT_ID>';
const ORGANIZATION_ID = '<ORGANIZATION_ID>';

async function listarAtividades() {
  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${TOKEN}`,
    'OrganizationId': ORGANIZATION_ID,
  };

  const query = {
    query: `
      query {
        listingActivities(
          folderId: ${FOLDER_ID},
          accountId: ${ACCOUNT_ID}
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
      const dados = response.data?.data?.listingActivities;
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

listarAtividades();
