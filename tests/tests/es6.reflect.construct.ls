QUnit.module 'ES6 Reflect.construct'

{getPrototypeOf} = Object

eq = strictEqual

test '*' !->
  {construct} = Reflect
  ok typeof! construct is \Function, 'Reflect.construct is function'
  eq construct.length, 2, 'arity is 2'
  ok /native code/.test(construct), 'looks like native'
  if \name of construct => eq construct.name, \construct, 'name is "construct"'
  C = (a, b, c)-> @qux = a + b + c
  eq construct(C, <[foo bar baz]>).qux, \foobarbaz, \basic
  C.apply = 42
  eq construct(C, <[foo bar baz]>).qux, \foobarbaz, 'works with redefined apply'
  inst = construct((-> @x = 42), [], Array)
  eq inst.x, 42, 'constructor with newTarget'
  ok inst instanceof Array, 'prototype with newTarget'
  throws (-> construct 42, []), TypeError, 'throws on primitive'
  f = (->)
  f:: = 42
  ok try getPrototypeOf(construct f, []) is Object::
  catch => no