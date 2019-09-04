# yeahlol.lua - YEt Another Homespun Lua OOP Library

![yeahlol.lua filesize](https://img.shields.io/github/size/slavfox/yeahlol.lua/yeahlol.lua)

`yeahlol.lua` is a tiny, <50 line <1KB class module for Lua designed to
imitate Python's class handling. It's heavily inspired by
[rxi/classic](https://github.com/rxi/classic), but aims to provide nicer support
for mixins and multiple inheritance.

`yeahlol.lua` export a single function - the class definition method.

It takes a list of parent classes as an argument, and returns a function that
takes a table of attribute definitions. This allows for idiomatic class
definitions that imitate most other OOP languages:
```lua
class = require "yeahlol"

MyClass = class(Superclass1, Superclass2) {
  attr1 = 1,
  attr2 = 2,

  method = function(self, ...)
    do_stuff()
  end
}
```

# Usage

Throw `yeahlol.lua` into your project directory and `require` it:
```lua
class = require "yeahlol"
```

The `class` function can now be used to define classes:

```lua
-- Define a new class
Animal = class() {
  -- Attributes
  species = "animal",

  -- Methods
  walk = function(self)
    print("The " .. self.species .. " walks a couple steps.")
  end,

  -- Magic methods
  __tostring = function(self)
    return self.species
  end
}
```

Create an instance of a class by calling the class:
```lua
-- Instantiate a class
animal = Animal()
```

You can then use it as expected:
```lua
print(animal) -- "animal"
animal:walk() -- "The animal walks a couple steps."
```

## Customizing initialization

Just like in Python, you can define an `_init` method on your class to assign
attributes and do other things on instantiation:
```lua
Car = class() {
  _init = function(self, color)
    self.color = color
  end
}

my_car = Car("red")
print(my_car.color) -- red
```

## (Multiple) Inheritance

Multiple inheritance works. The MRO is left-to-right (or, alternately, the
superclasses passed earlier override the methods from the later ones).

If you have a class `C = class(A, B){}`, and `A` and `B` both define a method
`foo`, then `C.foo` is going to use the definition from `A`.

To refer to the superclass's original method/attribute that you're overriding,
use `self.super`.

```lua
PettableMixin = class() {
  texture = "abstract",

  pet = function(self)
    print("You pet the " .. self.species .. ". It's " .. self.texture .. "!")
  end
}

Dog = class(Animal, PettableMixin) {
  species = "dog",
  texture = "fuzzy",

  -- Initializer - gets called on class instantiation.
  -- If you want to modify the creation of the class instance itself, override
  -- `_new()` - just like in Python!
  _init = function(self, name)
    self.name = name
  end,

  bark = function(self)
    print(self.name .. " barks loudly!")
  end,

  __tostring = function(self)
    return self.name
  end
}

fido = Dog("Fido")
fido:bark() -- "Fido barks loudly!"
fido:walk() -- "The dog walks a couple steps"
fido:pet() -- "You pet the dog. It's fuzzy!"

SizedDog = class(Dog) {
  _init = function(self, name, size)
    -- use .super to refer to the parent's methods in a subclass
    self.super._init(self, name)
    self.species = size .. " dog"
  end
}

max = SizedDog("Max", "big")
max:bark() -- "Max barks loudly!"
max:walk() -- "The big dog walks a couple steps."
max:pet() -- "You pet the big dog. It's fuzzy!"

-- You can also define attributes after the class definition:
max.breed = "St. Bernard"
-- Be careful about this!
function SizedDog:__tostring()
  return self.breed
end
print(max) -- "St. Bernard"

-- You can also override instance methods and attributes just as easily, but
-- not magic methods!
function max:print_breed()
  print(self.name .. " is a " .. self.breed)
end

function max:__tostring()
  return "Nope"
end

max:print_breed() -- "Max is a St. Bernard"
print(max) -- "St. Bernard"
```

# License

yeahlol is available under the [Mozilla Public License Version
2.0](https://mozilla.org/MPL/2.0/), the full text of which can be found in
[LICENSE](LICENSE).

💙
