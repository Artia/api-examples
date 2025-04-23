const axios = require('axios');

const ENDPOINT = 'https://api.artia.com/graphql';
const TOKEN = '<TOKEN>';
const ID = '<ID>';
const ACCOUNT_ID = '<ACCOUNT_ID>';
const ORGANIZATION_ID = '<ORGANIZATION_ID>';

async function removerAtividade() {
  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${TOKEN}`,
    'OrganizationId': ORGANIZATION_ID,
  };

  const query = {
    query: `
      mutation {
        destroyActivities(
          ids: [${ID}],
          accountId: ${ACCOUNT_ID}
        ) {
          message
        }
      }
    `,
    variables: {}
  };

  try {
    const response = await axios.post(ENDPOINT, query, { headers });

    if (response.status === 200) {
      const dados = response.data?.data?.destroyActivities;
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

removerAtividade();
