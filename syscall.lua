-- this puts everything into one table ready to use

local require, print, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string, math = 
require, print, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string, math

local abi = require "syscall.abi"

local ffi = require "ffi"

local useos = abi.os
if abi.rump and abi.types then useos = abi.types end

require "syscall.ffitypes"
require("syscall." .. useos .. ".ffitypes")

if not abi.rump then require "syscall.ffifunctions" end

local c = require("syscall." .. useos .. ".constants")
local errors = require("syscall." .. abi.os .. ".errors") -- note this is correct, emulation still gives NetBSD errors
local ostypes = require("syscall." .. useos .. ".types")

local ostypes2
if abi.rump and abi.types == "linux" then ostypes2 = require "syscall.rump.linux" end

local types = require "syscall.types".init(c, errors, ostypes, ostypes2)

local C
if abi.rump then
  C = require("syscall.rump.c")
else
  C = require("syscall." .. abi.os .. ".c")
end

if abi.rump and abi.types == "linux" then abi.os = "linux" end -- after this, we pretend to be Linux

-- from now useos and abi.os the same

local ioctl = require("syscall." .. abi.os .. ".ioctl").init(types)
local fcntl = require("syscall." .. abi.os .. ".fcntl").init(types)

local S = require "syscall.syscalls".init(c, C, types, ioctl, fcntl)

c.IOCTL = ioctl -- cannot put in S, needed for tests, cannot be put in c earlier due to deps  TODO remove see #94

S.abi, S.c, S.types, S.t = abi, c, types, types.t -- add to main table returned

-- add compatibility code
S = require "syscall.compat".init(S)

-- add functions from libc
S = require "syscall.libc".init(S)

-- add methods
S = require "syscall.methods".init(S)

-- add feature tests
S.features = require "syscall.features".init(S)

-- link in fcntl
S.__fcntl = fcntl

-- add utils
S.util = require "syscall.util".init(S)

if abi.os == "linux" then
  S.cgroup = require "syscall.linux.cgroup".init(S)
  S.nl = require "syscall.linux.nl".init(S)
  -- TODO add the other Linux specific modules here
end

return S


