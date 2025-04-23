const axios = require('axios');

const ENDPOINT = 'https://api.artia.com/graphql';
const CLIENT_ID = '<CLIENT_ID>';
const SECRET = '<SECRET>';

async function gerarToken() {
  const headers = {
    'Content-Type': 'application/json',
  };

  const query = {
    query: `
      mutation {
        authenticationByClient(
          clientId: "${CLIENT_ID}",
          secret: "${SECRET}"
        ) {
          token
        }
      }
    `,
    variables: {},
  };

  try {
    const response = await axios.post(ENDPOINT, query, { headers });

    if (response.status === 200) {
      const token = response.data?.data?.authenticationByClient?.token;
      console.log("Token final:", token);
      return token;
    } else {
      console.error(`Erro na requisição: ${response.status} - ${response.statusText}`);
      return null;
    }
  } catch (error) {
    console.error("Erro inesperado:", error.message);
    return null;
  }
}

gerarToken();
