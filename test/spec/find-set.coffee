'use strict'

describe 'Service: _ou findSet', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'findSet && findSetIndex', ->
    arr = [
      {variant: {foo: 1}, $id: 'foo', count: 0}
      {variant: {foo: 2}, $id: 'bar', count: 0}
    ]

    set = {variant: {foo: 1}, $id: 'foo'}
    expect(util.findSet arr, set ).toEqual(arr[0])
    expect(util.findSetIndex arr, set).toBe 0

    set = {variant: {foo: 2}, $id: 'bar'}
    expect(util.findSet arr, set ).toEqual(arr[1])
    expect(util.findSetIndex arr, set).toBe 1

    set = {variant: {foo: 1}, $id: 'bar'}
    expect(util.findSet arr, set).toBeUndefined
    expect(util.findSetIndex arr, set).toBeUndefined

    set = variant: {foo: 1}
    expect(util.findSet arr, set).toEqual(arr[0])
    expect(util.findSetIndex arr, set).toBe 0

    set = variant: {foo: 2}
    expect(util.findSet arr, set).toEqual(arr[1])
    expect(util.findSetIndex arr, set).toBe 1

    set = {variant: {foo: 1}, $id: 'no'}
    expect(util.findSet arr, set).toBeUndefined
    expect(util.findSetIndex arr, set).toBeUndefined

  it 'findSet and inc count', ->
    arr = [
      {variant: {foo: 1}, $id: 'foo', count: 0},
      {variant: {foo: 2}, $id: 'bar', count: 0}
    ]

    found = util.findSet arr, {variant: {foo: 1}, $id: 'foo'}
    found.count += 1

    index = util.findSetIndex arr, {variant: {foo: 2}, $id: 'bar'}
    arr[index].count += 2

    expect(arr[0].count).toBe 1
    expect(arr[1].count).toBe 2
    expect(index).toBe 1
