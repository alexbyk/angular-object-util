angular-object-util
===================
### Installation

```bower install --save angular-object-util```

### Usage

```js
app.module('myApp').controller(function('_ou', $scope){
  # $scope.foo() to $scope.bar.foo()
  _ou.delegateMethod($scope, 'bar', 'foo')
});
```

### Documentation

Documentation is available [here](http://alexbyk.github.io/angular-object-util/angular-object-util.html), currently as docco comments
