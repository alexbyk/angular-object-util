'use strict'

describe 'Service: _ou delegateMethod', ->

  # load the service's module
  beforeEach module 'object-util'

  # instantiate service
  util = {}
  beforeEach inject (_ou) ->
    util = _ou

  it 'delegateMethod', ->
    client = foo: -> 'foo'
    obj = client: client 
    util.delegateMethod(obj, 'client', 'foo')

    expect(obj.hasOwnProperty('foo')).toBe true
    expect(obj.foo()).toBe 'foo'

  it 'delegateMethods by array', ->
    client = 
      foo1: -> 'foo1'
      foo2: -> 'foo2'

    obj = client: client 
    util.delegateMethod(obj, 'client', ['foo1', 'foo2'])

    expect(obj.hasOwnProperty('foo1')).toBe true
    expect(obj.hasOwnProperty('foo2')).toBe true
    expect(obj.foo1()).toBe 'foo1'
    expect(obj.foo2()).toBe 'foo2'

  it 'delegateMethod by map', ->
    client = 
      bar1: -> 'bar1'
      bar2: -> 'bar2'
    obj = client: client 
    util.delegateMethod(obj, 'client', {foo1: 'bar1', foo2: 'bar2'})

    expect(obj.hasOwnProperty('foo1')).toBe true
    expect(obj.hasOwnProperty('foo2')).toBe true
    expect(obj.foo1()).toBe 'bar1'
    expect(obj.foo2()).toBe 'bar2'

  it 'delegateMethods with map', ->
    map = foo1: 'bar1', foo2: 'bar2'
    client = 
      foo1: -> 'foo1'
      foo2: -> 'foo2'

    obj = client: client 
    util.delegateMethod(obj, 'client', ['foo1', 'foo2'])

    expect(obj.hasOwnProperty('foo1')).toBe true
    expect(obj.hasOwnProperty('foo2')).toBe true
    expect(obj.foo1()).toBe 'foo1'
    expect(obj.foo2()).toBe 'foo2'

  it 'delegateMethod this must be attr', ->
    client = 
      getType: -> @type
      type: 'client'

    obj = client: client 
    util.delegateMethod(obj, 'client', 'getType')

    expect(obj.hasOwnProperty('getType')).toBe true
    expect(obj.getType()).toBe 'client'

  it 'delegateMethod check how prototypes work', ->
    client = 
      getType: -> @type
      type: 'client'

    class MyClass
      constructor: (client) -> @client = client

    obj = new MyClass(client)
    util.delegateMethod(MyClass::, 'client', 'getType')

    expect(obj.hasOwnProperty('getType')).toBe false
    expect(obj.getType()).toBe 'client'

  it 'delegateMethod throws bad attr', ->
    obj = {}
    util.delegateMethod(obj, 'badClient', 'badMethod')
    expect(obj.badMethod).toBeDefined
    err = null
    try obj.badMethod()
    catch e
      err = e.message
    expect(e.message).toMatch "badClient doesn't exist"

  it 'delegateMethod throws bad method in attr', ->
    client = {}
    obj = {client: client}
    util.delegateMethod(obj, 'client', 'badMethod')
    expect(obj.badMethod).toBeDefined
    err = null
    try obj.badMethod()
    catch e
      err = e.message
    expect(err).toMatch "badMethod doesn't exist"
