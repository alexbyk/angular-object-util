'use strict'

describe 'Service: _ou equals', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'equals values', ->
    expect(util.equals({$foo: 2}, {$foo: 2})).toBe true
    expect(util.equals({$foo: 2}, {$foo: 3})).toBe false

    expect(util.equals(
      {$foo: 2, bar:[1,2], baz: {a: 'b'}},
      {$foo: 2, bar:[1,2], baz: {a: 'b'}}
    )).toBe true

    expect(util.equals(
      {bar:[1,2], $foo: 2},
      {$foo: 2, bar:[1,2]}
    )).toBe true

    expect(util.equals(
      {$foo: 2, bar:[1,2]},
      {$foo: 2})
    ).toBe false

    expect(util.equals(
      {$foo: 2, bar: {foo: 1}},
      {$foo: 2, bar: {foo: 1}})
    ).toBe true

    expect(util.equals(
      {$foo: 1, bar: {foo: 1}},
      {$foo: 2, bar: {foo: 1}})
    ).toBe false

    expect(util.equals(
      {$foo: 2, bar: {foo: 1}},
      {$foo: 2, bar: {foo: 2}})
    ).toBe false

    expect(util.equals(
      {$foo: 2, bar: {foo: 1}},
      {$foo: 2})
    ).toBe false
