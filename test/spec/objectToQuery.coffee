'use strict'

describe 'Service: _ou objectToQuery', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'objectToQuery', ->
    expect(util.objectToQuery({foo: 1, bar: 2})).toBe 'foo=1&bar=2'
    expect(util.objectToQuery({foo: '&', bar: 2})).toBe 'foo=%26&bar=2'
    expect(util.objectToQuery({})).toBe ''




