'use strict'

describe 'Service: _ou mapKeys', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'mapKeys Combined', ->
    obj = {foo: 2, a: ['foo', {foo: 3, f: 1, foo2: '4'}], f: {foo: 2, f: 1}}
    mapped = util.mapKeys(obj, {foo: 'bar', foo2: 'bar2'})
    obj.a[0] = 'changed'
    obj.a[1].f = 'changed'
    expect(mapped).toEqual {bar: 2, a: ['foo', {bar: 3, f: 1, bar2: '4'}], f: {bar: 2, f: 1}}


  it 'mapKeys Object', ->
    obj = {foo: 'foo', bar: 'bar', baz: 'baz'}
    map = {foo: '_foo', bar: '_bar'}
    mapped = util.mapKeys(obj, map);
    obj.baz = 'changed'
    expect(mapped).toEqual {_foo: 'foo', _bar: 'bar', baz: 'baz'}

  it 'mapKeys Array', ->
    obj = [{foo: 'foo', baz: 'baz'}]
    map = {foo: '_foo'}
    mapped = util.mapKeys(obj, map)
    obj[0].baz = "changed"
    expect(mapped).toEqual [{_foo: 'foo',  baz: 'baz'}]

  it 'mapKeys Array without object must do nothing', ->
    obj = [1, 2, 3]
    map = {foo: '_foo'}
    mapped = util.mapKeys(obj, map)
    obj[0] = 'changed'
    expect(mapped).toEqual [1,2,3]
