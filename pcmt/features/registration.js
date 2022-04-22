'use strict'

const {Given, When, Then, setDefaultTimeout} = require('@cucumber/cucumber')

const {
  verifyPcmtRunning,
  getSystemInfo,
} = require('./utils')

setDefaultTimeout(10000)

Given('that PCMT is set up', verifyPcmtRunning)

Then('PCMT should respond to an authenticated API request', getSystemInfo)
