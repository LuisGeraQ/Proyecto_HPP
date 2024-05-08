const fetch = require('node-fetch');

async function getToken(req, res) {
  const url = "https://api.ibicare.mx/api/login";
  const datosUsuario = {
    user_name: "paola.aranda",
    password: "66A171B7A7F"
  };

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(datosUsuario)
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    res.json({ token: data.sessiontoken });
  } catch (error) {
    console.error('Error al obtener el token:', error);
    res.status(500).json({ error: error.message });
  }
}

module.exports = { getToken };
