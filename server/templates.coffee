'use strict'

fs = require 'fs'
path = require 'path'
handlebars = require 'handlebars'
log = require './log'

layoutPath = path.resolve __dirname, '../views/layout.html'

initialise = ->
  log = log.initialise 'templates'
  log.info 'initialising'

  handlebars.registerHelper 'block', blockHelper
  handlebars.registerHelper 'partial', partialHelper

  fs.readFile layoutPath, encoding: 'utf8', registerLayout

blockHelper = (name, options) ->
  if typeof handlebars.partials[name] is 'string'
    log.info "compiling partial `#{name}`"
    handlebars.partials[name] = handlebars.compile handlebars.partials[name]

  partial = handlebars.partials[name] || options.fn;

  log.info "rendering partial `#{name}`"
  partial this, data: options.hash

partialHelper = (name, options) ->
  log.info "registering partial `#{name}`"
  handlebars.registerPartial name, options.fn

registerLayout = (error, template) ->
  if error
    log.error "fatal error reading layout.html, `#{error}`"
    process.exit 1

  log.info 'registering layout partial'
  handlebars.registerPartial 'layout', handlebars.compile template

module.exports = { initialise }

