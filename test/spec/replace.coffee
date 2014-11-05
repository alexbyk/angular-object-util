'use strict'

describe 'Service: _ou replace', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'replace obj', ->
    dst = {bad: 1}
    src = {foo: 1, bar: 2}
    util.replace(dst,src)
    expect(dst).toEqual {foo: 1, bar: 2}

  it 'replace obj', ->
    dst = [0]
    src = [1,2]
    util.replace(dst,src)
    expect(dst).toEqual [1,2]




