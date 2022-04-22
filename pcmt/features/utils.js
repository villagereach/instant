'use strict'

const axios = require('axios')

const PCMT_PROTOCOL = process.env.PCMT_PROTOCOL || 'http'
const PCMT_API_HOSTNAME = process.env.PCMT_API_HOSTNAME || 'localhost'
const PCMT_API_PASSWORD = process.env.PCMT_API_PASSWORD || 'api_secret'
const PCMT_API_PORT = process.env.PCMT_API_PORT || 80
const PCMT_API_USERNAME = process.env.PCMT_API_USERNAME || '1_api_connection_1'

const authHeader = new Buffer.from(
  `${PCMT_API_USERNAME}:${PCMT_API_PASSWORD}`
).toString('base64')

exports.verifyPcmtRunning = async () => {
  const options = {
    url: `${PCMT_PROTOCOL}://${PCMT_API_HOSTNAME}:${PCMT_API_PORT}/`,
    method: 'GET'
  }

  try {
    const response = await axios(options)

    if (response && response.status === 200) {
      console.log(`PCMT running`)
    } else {
      throw new Error('PCMT NOT running!')
    }
  } catch (error) {
    throw new Error(`PCMT issues: ${error.message}`)
  }
}

exports.getSystemInfo = async () => {
  const tokenResponse = await axios.post(`${PCMT_PROTOCOL}://${PCMT_API_HOSTNAME}:${PCMT_API_PORT}/api/oauth/v1/token`,
    {
      grant_type: 'password',
      username: 'admin',
      password: 'Admin123'
    },
    {
    headers: {
          Authorization: `Basic ${authHeader}`,
          'Content-Type': 'application/json'
        }
    }
  )

  if (tokenResponse && tokenResponse.status === 200) {
    const token = tokenResponse.data.access_token
    //using this API for now until PCMT is Akeneo v6, then we can use /api/rest/v1/system-information
    const response = await axios.get(`${PCMT_PROTOCOL}://${PCMT_API_HOSTNAME}:${PCMT_API_PORT}/api/rest/v1`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      }
    )

    if (response && response.status === 200) {
      console.log('Get system info successful')
    } else {
      throw Error(`Get system info failed: ${response.data}`)
    }
  } else {
    throw Error(`Get auth token failed: ${tokenResponse.data}`)
  }
}
