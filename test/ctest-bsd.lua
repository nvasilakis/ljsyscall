-- generate C test file to check type sizes etc
-- Currently run for BSD TODO split into portable subset and BSD specific
-- would need filtering to only test portable items though to run under Linux

local ffi = require "ffi"
local abi = require "syscall.abi"
local types = require "syscall.types"
local t, ctypes, s = types.t, types.ctypes, types.s
local c = require "syscall.constants"

c.IOCTL = require "syscall.ioctl"

print [[
/* this code is generated by ctest.lua */

#define _BSD_SOURCE
#define _FILE_OFFSET_BITS 64
#define _LARGE_FILES 1
#define __USE_FILE_OFFSET64

#include <stddef.h>
#include <stdint.h>

#include <stdio.h>
#include <limits.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/udp.h>
#include <arpa/inet.h>
#include <signal.h>
#include <sys/utsname.h>
#include <time.h>
#include <sys/resource.h>
#include <sys/sysinfo.h>
#include <sys/time.h>
#include <sys/un.h>
#include <netinet/ip.h>
#include <poll.h>
#include <sys/timex.h>
#include <sys/mman.h>
#include <sched.h>
#include <sys/xattr.h>
#include <termios.h>
#include <unistd.h>
#include <sys/mount.h>
#include <sys/uio.h>
#include <net/route.h>
#include <sys/inotify.h>
#include <sys/wait.h>
#include <dirent.h>
#include <syscall.h>
#include <sys/ioctl.h>

int ret = 0;

void sassert(int a, int b, char *n) {
  if (a != b) {
    printf("error with %s: %d (0x%x) != %d (0x%x)\n", n, a, a, b, b);
    ret = 1;
  }
}

void sassert_u64(uint64_t a, uint64_t b, char *n) {
  if (a != b) {
    printf("error with %s: %llu (0x%llx) != %llu (0x%llx)\n", n, (unsigned long long)a, (unsigned long long)a, (unsigned long long)b, (unsigned long long)b);
    ret = 1;
  }
}

int main(int argc, char **argv) {
]]

-- iterate over S.ctypes
for k, v in pairs(ctypes) do
  print("sassert(sizeof(" .. k .. "), " .. ffi.sizeof(v) .. ', "' .. k .. '");')
end

-- test all the constants

-- renamed ones
local nm = {
  E = "E",
  SIG = "SIG",
  STD = "STD",
  MODE = "S_I",
  MSYNC = "MS_",
  W = "W",
  POLL = "POLL",
  S_I = "S_I",
  LFLAG = "",
  IFLAG = "",
  OFLAG = "",
  CFLAG = "",
  CC = "",
  IOCTL = "",
  B = "B",
  SYS = "__NR_",
}

for k, v in pairs(c) do
  if type(v) == "number" then
    print("sassert(" .. k .. ", " .. v .. ', "' .. k .. '");')
  elseif type(v) == "table" then
    for k2, v2 in pairs(v) do
      local name = nm[k] or k .. "_"
      if type(v2) ~= "function" then
        if type(v2) == "cdata" and ffi.sizeof(v2) == 8 then
         print("sassert_u64(" .. name .. k2 .. ", " .. tostring(v2)  .. ', "' .. name .. k2 .. '");')
        else
         print("sassert(" .. name .. k2 .. ", " .. tostring(v2)  .. ', "' .. name .. k2 .. '");')
        end
      end
    end
  end
end

print [[
return ret;
}
]]

