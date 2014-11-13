'use strict'

angular.module('object-util', [])
.factory '_ou', ->

# **_ou.proxyMethod**`(dest, source, methods, argsUnshift)`
#
# creates a proxy methods that will invoke `methods` in `source` object and
# installs it into `dest` object.
#
# `this` in method will be a `source` object
#
# `methods` is a map of the methods  where keys are the names that will be used
# for methods in `dest` object, and values are the names of `source` methods
# in the form `{'destMethod': 'sourceMethod'}`
#
# if `methods` isn't an Object, it will be convirted to it using `_ou.toMap`
#
#     source =
#       foo1: -> 'foo1'
#       foo2: -> 'foo2'
#
#     dest = {}
#     _ou.proxyMethod(dest, source, {bar1: 'foo1', bar2: 'foo2'})
#
#     # 'foo1'
#     console.log dest.bar1()
#
# `argsUnshift` could be an array of any types or a single object. If provided,
# than actual arguments will be passed after unshifting them.
# Convinient when you whant to proxy methods source service to controller whis
# some common default value
#
#     source = foo: (name, lastname) -> "foo-#{name}-#{lastname}"
#     dest   = {}
#
#     # now dest.foo(lastname) will be the same as source.foo('alex', lastname)
#     _ou.proxyMethod(dest, source, 'foo', 'alex')
#     # 'foo-alex-cartman'
#     console.log dest.foo('cartman')
#
#     # 2 arguments will be unshifted dest real method
#     _ou.proxyMethod(dest, source, 'foo', ['alex', 'cartman'])
#     # 'foo-alex-cartman'
#     console.log dest.foo()
#

  _proxyMethod = (dest, source, dMeth, sMeth, argsUnshift=[]) ->
    dest[dMeth] = (args...) ->
      args.unshift(arg) for arg in argsUnshift.reverse()
      msg = "#{source}.#{sMeth} isn't a function"
      throw msg new Error unless typeof(source[sMeth]) == 'function'
      source[sMeth].apply(source, args)

  proxyMethod = (dest, source, methods, argsUnshift=[]) ->
    map = toMap(methods)
    argsUnshift = [argsUnshift] unless Array.isArray argsUnshift
    for dMeth, sMeth of map
      _proxyMethod(dest, source, dMeth, sMeth, argsUnshift)

# ** _ou.delegateMethod** `(object, attr, methods)`
#
# delegates a method to an attribute. `attr` is a string, a name of attribute.
#
# `methods` is a map of the methods  where keys are the names that will be used
# for methods in object, and values are the names of source methods in `obj.attr`
# in the form `{'objMethod': 'attrMethod'}`
#
# if method isn't an Object, it will be convirted to it using `_ou.toMap`
#
# When invoking, `this` will be `obj[attr]`
#
#     client = foo: -> 'foo'
#     obj = client: client
#     _ou.delegateMethod(obj, 'client', 'foo')
#
#     # "foo", the same as obj.client.foo()
#     console.log obj.foo()
#
#     # install under another name
#     _ou.delegateMethod(obj, 'client', {bar: 'foo'})
#
#     # "foo", the same as obj.client.foo()
#     console.log obj.bar()
#
# If you want to hide method from own attribute, you can pass a prototype.
# Because `this` will be `obj[attr]`, it will work
#
#     client =
#       getType: -> @type
#       type: 'client'
#
#     class MyClass
#       constructor: (client) -> @client = client
#
#     obj = new MyClass(client)
#     _ou.delegateMethod(MyClass::, 'client', 'getType')
#
#     # 'client'
#     console.log obj.getType()
#
  _delegateMethod = (object, attr, objMeth, attrMeth) ->
    object[objMeth] = () ->
      unless attrObj = @[attr]
        err = "Attribute with name #{attr} doesn't exist in #{object}"
        throw new Error (err) unless attrObj

      unless method = attrObj[attrMeth]
        err = "Method with name #{attrMeth} doesn't exist
          in #{attrObj} (#{attr})"
        throw new Error(err) unless method

      method.apply attrObj, arguments

  delegateMethod = (object, attr, methods) ->
    map = toMap(methods)
    _delegateMethod(object, attr, oMeth, aMeth) for oMeth, aMeth of map

# **_ou.toMap**`(data)`
#
# returns an object from array, string or object
#
# when `data` is neither `String` no `Array`, returns it without modifications
#
# when `data` is `String` with value `"value"`, returns `{value: "value"}` object
#
# when data is `Array` with value `['v1', 'v2']`, returns `{v1: "v1", v2: "v2"}` and so on

  toMap = (data) ->
    map = {}
    switch
      when angular.isString(data) then map[data] = data
      when angular.isArray(data)  then map[key] = key for key in data
      else map = data
    map

# **_ou.filterKeysNot**`(object, re)`
#
# returns a new recursively filtered object form `object` without keys that match `re`
#
#      obj = {foo: 2, bar: [{foo: 3, bar: 4}]}
#      # {bar: [bar: 4]}
#      console.log _ou.filterKeysNot(obj, /^foo$/)
#
# filters keys of objects only. so
#
#      unfiltered = ['foo', 'bar', {foo: 'bar', ok: 1}]
#      filtered = _ou.filterKeysNot(unfiltered)
#
#      # `['foo', 'bar', {ok: 1}]`
#      console.log filtered

  filterKeysNot = (object, re) ->
    _filter = (obj) ->
      switch
        when typeof obj != 'object' then obj
        when Array.isArray obj
          _filter val for val in obj
        else
          res = {}
          res[key] = _filter val for own key, val of obj when not re.test(key)
          res
    _filter(object)

# **_ou.mapKeys`(obj, map)`**
#
# returns a new object from `obj` where keys are recursively renamed by `map`
#
#      obj = {foo: 'foo', bar: 'bar', baz: 'baz'}
#      map = {foo: '_foo', bar: '_bar'}
#      mapped = util.mapKeys(obj, map);
#      expect(mapped).toEqual {_foo: 'foo', _bar: 'bar', baz: 'baz'}
#
#      obj = [{foo: 'foo', baz: 'baz'}]
#      map = {foo: '_foo'}
#      mapped = util.mapKeys(obj, map)
#      expect(mapped).toEqual [{_foo: 'foo',  baz: 'baz'}]

  mapKeys = (obj, rMap) ->
    rKeys = Object.keys(rMap)
    _map = (obj) ->
      switch
        when typeof obj != 'object' then obj
        when Array.isArray obj
          _map val for val in obj
        else
          res = {}
          for own key, val of obj # check in rMap
            newkey = if key in rKeys then rMap[key] else key
            res[newkey] = _map val
          res

    _map(obj)

# **_ou.replace`(dest, source)`**
#
# replaces `dest` object with the content of `source` object by ref, removing
# previous content from `dest`

#      dst = {bad: 1}
#      src = {foo: 1, bar: 2}
#      util.replace(dst,src)
#      expect(dst).toEqual {foo: 1, bar: 2}

  replace = (dst, src) ->
    delete dst[key] for own key of dst
    angular.extend dst, src
 
# **_ou.objectToQuery`(object)`**
#
# converts object to query string
#
#      #'foo=1&bar=2'
#      util.objectToQuery({foo: 1, bar: 2})
#
#      # 'foo=%26&bar=2'
#      util.objectToQuery({foo: '&', bar: 2})

  objectToQuery = (object) ->
    arr = []
    for own key,val of object
      encoded = encodeURIComponent(val)
      arr.push("#{key}=#{encoded}")
    arr.join('&')

# ** _ou.equalSets`(o1, o2, keys)`**
#
# tests if 2 objects have the same sets by given keys.
# returns true or false
#
#      o1 = eq: {foo: 1}, no: 'a'
#      o2 = eq: {foo: 1}, no: 'b'
#
#      # true
#      _ou.equalSets(o1, o2, ['eq'])
#
#      # false
#      _ou.equalSets(o1, o2, ['eq', 'no'])


  equalSets = (o1, o2, keys) ->
    angular.equals(o1, o2)
    for key in keys
      return false unless angular.equals o1[key], o2[key]

    return true


  {
    proxyMethod:    proxyMethod
    delegateMethod: delegateMethod
    toMap:          toMap
    filterKeysNot:  filterKeysNot
    mapKeys:        mapKeys
    replace:        replace
    objectToQuery:  objectToQuery
    equalSets:      equalSets
  }
