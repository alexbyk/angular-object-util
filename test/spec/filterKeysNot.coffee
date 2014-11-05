'use strict'

describe 'Service: _ou filterKeysNot', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'filter by regexp', ->
    obj = {foo: 2, bar: ['foo', {foo: 3, ok: 1}], ok: {foo: 2, ok: 1}}
    filtered = util.filterKeysNot(obj, /^foo/)
    obj.bar[1].ok = 'changed'
    expect(filtered).toEqual {bar: ['foo', {ok: 1}], ok: {ok: 1}}

  it 'filter by regexp', ->
    obj = ['foo', 'bar', {foo: 'bar', ok: 1}]
    filtered = util.filterKeysNot(obj, /^foo/)
    obj[2].ok = 'changed'
    expect(filtered).toEqual ['foo', 'bar', {ok: 1}]
