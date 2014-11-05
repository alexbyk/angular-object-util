(function() {
  'use strict';
  var __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('object-util', []).factory('_ou', function() {
    var delegateMethod, filterKeysNot, mapKeys, proxyMethod, replace, toMap, _delegateMethod, _proxyMethod;
    _proxyMethod = function(dest, source, dMeth, sMeth, argsUnshift) {
      if (argsUnshift == null) {
        argsUnshift = [];
      }
      return dest[dMeth] = function() {
        var arg, args, msg, _i, _len, _ref;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        _ref = argsUnshift.reverse();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          arg = _ref[_i];
          args.unshift(arg);
        }
        msg = "" + source + "." + sMeth + " isn't a function";
        if (typeof source[sMeth] !== 'function') {
          throw msg(new Error);
        }
        return source[sMeth].apply(source, args);
      };
    };
    proxyMethod = function(dest, source, methods, argsUnshift) {
      var dMeth, map, sMeth, _results;
      if (argsUnshift == null) {
        argsUnshift = [];
      }
      map = toMap(methods);
      if (!Array.isArray(argsUnshift)) {
        argsUnshift = [argsUnshift];
      }
      _results = [];
      for (dMeth in map) {
        sMeth = map[dMeth];
        _results.push(_proxyMethod(dest, source, dMeth, sMeth, argsUnshift));
      }
      return _results;
    };
    _delegateMethod = function(object, attr, objMeth, attrMeth) {
      return object[objMeth] = function() {
        var attrObj, err, method;
        if (!(attrObj = this[attr])) {
          err = "Attribute with name " + attr + " doesn't exist in " + object;
          if (!attrObj) {
            throw new Error(err);
          }
        }
        if (!(method = attrObj[attrMeth])) {
          err = "Method with name " + attrMeth + " doesn't exist in " + attrObj + " (" + attr + ")";
          if (!method) {
            throw new Error(err);
          }
        }
        return method.apply(attrObj, arguments);
      };
    };
    delegateMethod = function(object, attr, methods) {
      var aMeth, map, oMeth, _results;
      map = toMap(methods);
      _results = [];
      for (oMeth in map) {
        aMeth = map[oMeth];
        _results.push(_delegateMethod(object, attr, oMeth, aMeth));
      }
      return _results;
    };
    toMap = function(data) {
      var key, map, _i, _len;
      map = {};
      switch (false) {
        case !angular.isString(data):
          map[data] = data;
          break;
        case !angular.isArray(data):
          for (_i = 0, _len = data.length; _i < _len; _i++) {
            key = data[_i];
            map[key] = key;
          }
          break;
        default:
          map = data;
      }
      return map;
    };
    filterKeysNot = function(object, re) {
      var _filter;
      _filter = function(obj) {
        var key, res, val, _i, _len, _results;
        switch (false) {
          case typeof obj === 'object':
            return obj;
          case !Array.isArray(obj):
            _results = [];
            for (_i = 0, _len = obj.length; _i < _len; _i++) {
              val = obj[_i];
              _results.push(_filter(val));
            }
            return _results;
            break;
          default:
            res = {};
            for (key in obj) {
              if (!__hasProp.call(obj, key)) continue;
              val = obj[key];
              if (!re.test(key)) {
                res[key] = _filter(val);
              }
            }
            return res;
        }
      };
      return _filter(object);
    };
    mapKeys = function(obj, rMap) {
      var rKeys, _map;
      rKeys = Object.keys(rMap);
      _map = function(obj) {
        var key, newkey, res, val, _i, _len, _results;
        switch (false) {
          case typeof obj === 'object':
            return obj;
          case !Array.isArray(obj):
            _results = [];
            for (_i = 0, _len = obj.length; _i < _len; _i++) {
              val = obj[_i];
              _results.push(_map(val));
            }
            return _results;
            break;
          default:
            res = {};
            for (key in obj) {
              if (!__hasProp.call(obj, key)) continue;
              val = obj[key];
              newkey = __indexOf.call(rKeys, key) >= 0 ? rMap[key] : key;
              res[newkey] = _map(val);
            }
            return res;
        }
      };
      return _map(obj);
    };
    replace = function(dst, src) {
      var key;
      for (key in dst) {
        if (!__hasProp.call(dst, key)) continue;
        delete dst[key];
      }
      return angular.extend(dst, src);
    };
    return {
      proxyMethod: proxyMethod,
      delegateMethod: delegateMethod,
      toMap: toMap,
      filterKeysNot: filterKeysNot,
      mapKeys: mapKeys,
      replace: replace
    };
  });

}).call(this);
