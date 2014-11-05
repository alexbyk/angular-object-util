'use strict'

describe 'Service: _ou proxyMethod', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'proxyMethod basic', ->
    source = foo: -> 'foo'
    dest = {}
    util.proxyMethod(dest, source, 'foo')
    expect(dest.foo()).toBe 'foo'

    # changing method in source, should reflect to too)
    source.foo = -> 'bar'
    expect(dest.foo()).toBe 'bar'

    # but changing method in to shouldn't change source 
    dest.foo = -> 'baz'
    expect(dest.foo()).toBe 'baz'
    expect(source.foo()).toBe 'bar'

  it 'proxyMethod array of methods', ->
    source = 
      foo: -> 'foo'
      bar: -> 'bar'
    dest = {}
    util.proxyMethod(dest, source, ['foo', 'bar'])
    expect(dest.foo()).toBe 'foo'
    expect(dest.bar()).toBe 'bar'

  it 'proxyMethod with mapping', ->
    source = 
      foo1: -> 'foo1'
      foo2: -> 'foo2'

    dest = {}
    util.proxyMethod(dest, source, {bar1: 'foo1', bar2: 'foo2'})
    expect(dest.bar1()).toBe 'foo1'
    expect(dest.bar2()).toBe 'foo2'

  it 'proxyMethod with argsUnshift as one string', ->
    source = foo: (name, lastname) -> "foo-#{name}-#{lastname}"
    dest   = {}
    util.proxyMethod(dest, source, 'foo', 'alex')
    expect(dest.foo('cartman')).toBe 'foo-alex-cartman'

  it 'proxyMethod with argsUnshift as array', ->
    source = foo: (name, lastname, age) -> "foo-#{name}-#{lastname}-#{age}"
    dest   = {}
    util.proxyMethod(dest, source, 'foo', ['alex', 'cartman'])
    expect(dest.foo(22)).toBe 'foo-alex-cartman-22'

  it 'proxyMethod this must be the same', ->
    source = 
      type : 'foo'
      getType: -> @.type
    dest   = {}
    util.proxyMethod(dest, source, 'getType')
    expect(dest.getType()).toBe 'foo'

  it 'proxyMethod exceptions for non-existing method', ->
    source = {}
    dest = {}
    util.proxyMethod(dest, source, 'notExists')
    expect(dest.notExists).toBeDefined
    err = null

    try dest.notExists()
    catch e
      err = e.message

    expect(err).toMatch(".notExists isn't a function")



