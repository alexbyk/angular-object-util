'use strict'

describe 'Service: _ou toMap', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'toMap', ->
    expect(util.toMap('foo')).toEqual {foo: 'foo'}
    expect(util.toMap(['foo', 'bar'])).toEqual {foo: 'foo', bar: 'bar'}
    expect(util.toMap({foo: 'foo'})).toEqual {foo: 'foo'}
