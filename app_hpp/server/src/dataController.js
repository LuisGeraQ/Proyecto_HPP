const fetch = require('node-fetch');

async function getData(req, res) {
  const token = req.headers.authorization;
  const url = "https://api.ibicare.mx/api/clockData/myData?yearI=2024&monthI=04&dayI=1&yearF=2024&monthF=04&dayF=30";

  try {
    const response = await fetch(url, {
      method: 'GET',
      headers: { 'Authorization': token }
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('Error al obtener la información:', error);
    res.status(500).json({ error: error.message });
  }
}

module.exports = { getData };
