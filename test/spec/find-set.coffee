'use strict'

describe 'Service: _ou findSet', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'findSet', ->
    arr = [
      {variant: {foo: 1}, $id: 'foo', count: 0}
      {variant: {foo: 2}, $id: 'bar', count: 0}
    ]

    expect(util.findSet arr, {variant: {foo: 1}, $id: 'foo'})
      .toEqual({variant: {foo: 1}, $id: 'foo', count: 0})

    expect(util.findSet arr, {variant: {foo: 1}, $id: 'bar'}).toBeUndefined

    expect(util.findSet arr, variant: {foo: 1})
      .toEqual({variant: {foo: 1}, $id: 'foo', count: 0})

    expect(util.findSet arr, {variant: {foo: 1}, $id: 'no'}).toBeUndefined

  it 'findSet and inc count', ->
    arr = [
      {variant: {foo: 1}, $id: 'foo', count: 0}
    ]

    found = util.findSet arr, {variant: {foo: 1}, $id: 'foo'}
    found.count += 1

    expect(arr[0].count).toBe 1

