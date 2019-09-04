-- YeAHLOL - Yet Another Homespun Lua OOP Library
--
-- Copyright (c) 2019, slavfox
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.
return function(...)
  local bases = {...}
  local cls = {
    super = {}
  }
  local meta = {}

  function cls._init()
  end

  function cls:_new()
    local instance = setmetatable({}, self)
    return instance
  end

  function meta:__call(...)
    local instance = self:_new(...)
    instance:_init(...)
    return instance
  end

  for i = #bases, 1, -1 do
    for k, v in pairs(bases[i]) do
      if k ~= "super" then
        cls[k] = v
        cls.super[k] = v
      end
    end
  end

  setmetatable(cls, meta)
  cls.__index = cls
  return function(attrs)
    for k, v in pairs(attrs) do
      cls[k] = v
    end
    return cls
  end
end
