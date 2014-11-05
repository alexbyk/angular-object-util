angular-object-util
===================
### Installation

```bower install --save angular-object-util```

### Usage

```js
app.module('myApp').controller('myCtrl', function(_ou, $scope){
  // $scope.foo() -> $scope.bar.foo()
  _ou.delegateMethod($scope, 'bar', 'foo')
});
```

### Documentation

Documentation is available [here](http://alexbyk.github.io/angular-object-util/angular-object-util.html), currently as docco comments
