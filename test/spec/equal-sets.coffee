'use strict'

describe 'Service: _ou equalSets', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'equalSets values', ->
    o1 = foo: 1, bar: 2, baz: 31, own1: 41, $no: 1
    o2 = foo: 1, bar: 2, baz: 32, own2: 42, $no: 2
    expect(util.equalSets(o1, o2, ['foo', 'bar'])).toBe true
    expect(util.equalSets(o1, o2, ['foo', 'bar', 'baz' ])).toBe false
    expect(util.equalSets(o1, o2, ['foo', 'bar', 'own1' ])).toBe false
    expect(util.equalSets(o1, o2, ['foo', '$no'])).toBe false

  it 'equalSets deeper', ->
    o1 = eq: {foo: 1, bar: 2}, no: {foo: 11, bar: 2}
    o2 = eq: {foo: 1, bar: 2}, no: {foo: 12, bar: 2}
    expect(util.equalSets(o1, o2, ['eq'])).toBe true
    expect(util.equalSets(o1, o2, ['eq', 'no'])).toBe false

  it 'equalSets deeper $', ->
    o1 = $eq: {$foo: 1, $bar: 2}, $no: {$foo: 11, $bar: 2}
    o2 = $eq: {$foo: 1, $bar: 2}, $no: {$foo: 12, $bar: 2}
    expect(util.equalSets(o1, o2, ['$eq'])).toBe true
    expect(util.equalSets(o1, o2, ['$eq', '$no'])).toBe false

