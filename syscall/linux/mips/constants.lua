-- mips specific constants

local require, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string = 
require, error, assert, tonumber, tostring,
setmetatable, pairs, ipairs, unpack, rawget, rawset,
pcall, type, table, string

local h = require "syscall.helpers"

local octal = h.octal

local abi = require "syscall.abi"

local arch = {}

arch.SIG = {
  HUP = 1,
  INT = 2,
  QUIT = 3,
  ILL = 4,
  TRAP = 5,
  ABRT = 6,
  EMT = 7,
  FPE = 8,
  KILL = 9,
  BUS = 10,
  SEGV = 11,
  SYS = 12,
  PIPE = 13,
  ALRM = 14,
  TERM = 15,
  USR1 = 16,
  USR2 = 17,
  CHLD = 18,
  PWR = 19,
  WINCH = 20,
  URG = 21,
  IO = 22,
  STOP = 23,
  TSTP = 24,
  CONT = 25,
  TTIN = 26,
  TTOU = 27,
  VTALRM = 28,
  PROF = 29,
  XCPU = 30,
  XFSZ = 31,
}

arch.MAP = {
  SHARED     = 0x001,
  PRIVATE    = 0x002,
  TYPE       = 0x00f,
  FIXED      = 0x010,
  NORESERVE  = 0x0400,
  ANONYMOUS  = 0x0800,
  GROWSDOWN  = 0x1000,
  DENYWRITE  = 0x2000,
  EXECUTABLE = 0x4000,
  LOCKED     = 0x8000,
  POPULATE   = 0x10000,
  NONBLOCK   = 0x20000,
  STACK      = 0x40000,
  HUGETLB    = 0x80000,
}

local __O_SYNC = 0x4000

arch.O = {
  APPEND   = 0x0008,
  DSYNC    = 0x0010,
  NONBLOCK = 0x0080,
  CREAT    = 0x0100,
  TRUNC    = 0x0200,
  EXCL     = 0x0400,
  NOCTTY   = 0x0800,
  LARGEFILE= 0x2000,
  DIRECT   = 0x8000,
}

arch.O_SYNC = __O_SYNC + arch.O.DSYNC -- compatibility, see notes in header, we do not expose __O_SYNC TODO check if this is best way

arch.E = {
  PERM          =  1,
  NOENT         =  2,
  SRCH          =  3,
  INTR          =  4,
  IO            =  5,
  NXIO          =  6,
  ["2BIG"]      =  7,
  NOEXEC        =  8,
  BADF          =  9,
  CHILD         = 10,
  AGAIN         = 11,
  NOMEM         = 12,
  ACCES         = 13,
  FAULT         = 14,
  NOTBLK        = 15,
  BUSY          = 16,
  EXIST         = 17,
  XDEV          = 18,
  NODEV         = 19,
  NOTDIR        = 20,
  ISDIR         = 21,
  INVAL         = 22,
  NFILE         = 23,
  MFILE         = 24,
  NOTTY         = 25,
  TXTBSY        = 26,
  FBIG          = 27,
  NOSPC         = 28,
  SPIPE         = 29,
  ROFS          = 30,
  MLINK         = 31,
  PIPE          = 32,
  DOM           = 33,
  RANGE         = 34,
  NOMSG         = 35,
  IDRM          = 36,
  CHRNG         = 37,
  L2NSYNC       = 38,
  L3HLT         = 39,
  L3RST         = 40,
  LNRNG         = 41,
  UNATCH        = 42,
  NOCSI         = 43,
  L2HLT         = 44,
  DEADLK        = 45,
  NOLCK         = 46,
  BADE          = 50,
  BADR          = 51,
  XFULL         = 52,
  NOANO         = 53,
  BADRQC        = 54,
  BADSLT        = 55,
  DEADLOCK      = 56,
  BFONT         = 59,
  NOSTR         = 60,
  NODATA        = 61,
  TIME          = 62,
  NOSR          = 63,
  NONET         = 64,
  NOPKG         = 65,
  REMOTE        = 66,
  NOLINK        = 67,
  ADV           = 68,
  SRMNT         = 69,
  COMM          = 70,
  PROTO         = 71,
  DOTDOT        = 73,
  MULTIHOP      = 74,
  BADMSG        = 77,
  NAMETOOLONG   = 78,
  OVERFLOW      = 79,
  NOTUNIQ       = 80,
  BADFD         = 81,
  REMCHG        = 82,
  LIBACC        = 83,
  LIBBAD        = 84,
  LIBSCN        = 85,
  LIBMAX        = 86,
  LIBEXEC       = 87,
  ILSEQ         = 88,
  NOSYS         = 89,
  LOOP          = 90,
  RESTART       = 91,
  STRPIPE       = 92,
  NOTEMPTY      = 93,
  USERS         = 94,
  NOTSOCK       = 95,
  DESTADDRREQ   = 96,
  MSGSIZE       = 97,
  PROTOTYPE     = 98,
  NOPROTOOPT    = 99,
  PROTONOSUPPORT= 120,
  SOCKTNOSUPPORT= 121,
  OPNOTSUPP     = 122,
  PFNOSUPPORT   = 123,
  AFNOSUPPORT   = 124,
  ADDRINUSE     = 125,
  ADDRNOTAVAIL  = 126,
  NETDOWN       = 127,
  NETUNREACH    = 128,
  NETRESET      = 129,
  CONNABORTED   = 130,
  CONNRESET     = 131,
  NOBUFS        = 132,
  ISCONN        = 133,
  NOTCONN       = 134,
  UCLEAN        = 135,
  NOTNAM        = 137,
  NAVAIL        = 138,
  ISNAM         = 139,
  REMOTEIO      = 140,
  INIT          = 141,
  REMDEV        = 142,
  SHUTDOWN      = 143,
  TOOMANYREFS   = 144,
  TIMEDOUT      = 145,
  CONNREFUSED   = 146,
  HOSTDOWN      = 147,
  HOSTUNREACH   = 148,
  ALREADY       = 149,
  INPROGRESS    = 150,
  STALE         = 151,
  CANCELED      = 158,
  NOMEDIUM      = 159,
  MEDIUMTYPE    = 160,
  NOKEY         = 161,
  KEYEXPIRED    = 162,
  KEYREVOKED    = 163,
  KEYREJECTED   = 164,
  OWNERDEAD     = 165,
  NOTRECOVERABLE= 166,
  RFKILL        = 167,
  HWPOISON      = 168,
  DQUOT         = 1133,
}

arch.SFD = {
  CLOEXEC  = octal "02000000",
  NONBLOCK = octal "00000200",
}

arch.IN_INIT = {
  CLOEXEC  = octal("02000000"),
  NONBLOCK = octal("00000200"),
}

arch.SA = {
  ONSTACK     = 0x08000000,
  RESETHAND   = 0x80000000,
  RESTART     = 0x10000000,
  SIGINFO     = 0x00000008,
  NODEFER     = 0x40000000,
  NOCLDWAIT   = 0x00010000,
  NOCLDSTOP   = 0x00000001,
}

arch.SIGPM = {
  BLOCK     = 1,
  UNBLOCK   = 2,
  SETMASK   = 3,
}

arch.SI = {
  ASYNCNL = -60,
  TKILL = -6,
  SIGIO = -5,
  MESGQ = -4,
  TIMER = -3,
  ASYNCIO = -2,
  QUEUE = -1,
  USER = 0,
  KERNEL = 0x80,
}

arch.POLL = {
  IN          = 0x001,
  PRI         = 0x002,
  OUT         = 0x004,
  ERR         = 0x008,
  HUP         = 0x010,
  NVAL        = 0x020,
  RDNORM      = 0x040,
  RDBAND      = 0x080,
  WRBAND      = 0x100,
  MSG         = 0x400,
  REMOVE      = 0x1000,
  RDHUP       = 0x2000,
}

arch.POLL.WRNORM = arch.POLL.OUT

arch.RLIMIT = {
  CPU        = 0,
  FSIZE      = 1,
  DATA       = 2,
  STACK      = 3,
  CORE       = 4,
  NOFILE     = 5,
  AS         = 6,
  RSS        = 7,
  NPROC      = 8,
  MEMLOCK    = 9,
  LOCKS      = 10,
  SIGPENDING = 11,
  MSGQUEUE   = 12,
  NICE       = 13,
  RTPRIO     = 14,
  RTTIME     = 15,
}

-- note RLIM64_INFINITY looks like it varies by MIPS ABI but this is a glibc bug

arch.SO = {
  DEBUG       = 0x0001,
  REUSEADDR   = 0x0004,
  KEEPALIVE   = 0x0008,
  DONTROUTE   = 0x0010,
  BROADCAST   = 0x0020,
  LINGER      = 0x0080,
  OOBINLINE   = 0x0100,
--REUSEPORT   = 0x0200, -- not in kernel headers, although MIPS has had for longer
  TYPE        = 0x1008,
  ERROR       = 0x1007,
  SNDBUF      = 0x1001,
  RCVBUF      = 0x1002,
  SNDLOWAT    = 0x1003,
  RCVLOWAT    = 0x1004,
  SNDTIMEO    = 0x1005,
  RCVTIMEO    = 0x1006,
  ACCEPTCONN  = 0x1009,
  PROTOCOL    = 0x1028,
  DOMAIN      = 0x1029,

  NO_CHECK    = 11,
  PRIORITY    = 12,
  BSDCOMPAT   = 14,
  PASSCRED    = 17,
  PEERCRED    = 18,

  SECURITY_AUTHENTICATION = 22,
  SECURITY_ENCRYPTION_TRANSPORT = 23,
  SECURITY_ENCRYPTION_NETWORK = 24,
  BINDTODEVICE       = 25,
  ATTACH_FILTER      = 26,
  DETACH_FILTER      = 27,
  PEERNAME           = 28,
  TIMESTAMP          = 29,
  PEERSEC            = 30,
  SNDBUFFORCE        = 31,
  RCVBUFFORCE        = 33,
  PASSSEC            = 34,
  TIMESTAMPNS        = 35,
  MARK               = 36,
  TIMESTAMPING       = 37,
  RXQ_OVFL           = 40,
  WIFI_STATUS        = 41,
  PEEK_OFF           = 42,
  NOFCS              = 43,
--LOCK_FILTER        = 44, -- neither in our kernel headers
--SELECT_ERR_QUEUE   = 45,
}

arch.SO.STYLE = arch.SO.TYPE

arch.F = {
  DUPFD       = 0,
  GETFD       = 1,
  SETFD       = 2,
  GETFL       = 3,
  SETFL       = 4,
  GETLK       = 14,
  SETLK       = 6,
  SETLKW      = 7,
  SETOWN      = 24,
  GETOWN      = 23,
  SETSIG      = 10,
  GETSIG      = 11,
  GETLK64     = 33,
  SETLK64     = 34,
  SETLKW64    = 35,
  SETOWN_EX   = 15,
  GETOWN_EX   = 16,
  SETLEASE    = 1024,
  GETLEASE    = 1025,
  NOTIFY      = 1026,
  SETPIPE_SZ  = 1031,
  GETPIPE_SZ  = 1032,
  DUPFD_CLOEXEC = 1030,
}

arch.TIOCM = {
  LE  = 0x001,
  DTR = 0x002,
  RTS = 0x004,
  ST  = 0x010,
  SR  = 0x020,
  CTS = 0x040,
  CAR = 0x100,
  RNG = 0x200,
  DSR = 0x400,
  OUT1 = 0x2000,
  OUT2 = 0x4000,
  LOOP = 0x8000,
}

arch.CC = {
  VINTR         =  0,
  VQUIT         =  1,
  VERASE        =  2,
  VKILL         =  3,
  VMIN          =  4,
  VTIME         =  5,
  VEOL2         =  6,
  VSWTC         =  7,
  VSTART        =  8,
  VSTOP         =  9,
  VSUSP         = 10,
-- VDSUSP not supported
  VREPRINT      = 12,
  VDISCARD      = 13,
  VWERASE       = 14,
  VLNEXT        = 15,
  VEOF          = 16,
  VEOL          = 17,
}

arch.CC.VSWTCH = arch.CC.VSWTC

arch.LFLAG = {
  ISIG    = octal '0000001',
  ICANON  = octal '0000002',
  XCASE   = octal '0000004',
  ECHO    = octal '0000010',
  ECHOE   = octal '0000020',
  ECHOK   = octal '0000040',
  ECHONL  = octal '0000100',
  NOFLSH  = octal '0000200',
  IEXTEN  = octal '0000400',
  ECHOCTL = octal '0001000',
  ECHOPRT = octal '0002000',
  ECHOKE  = octal '0004000',
  FLUSHO  = octal '0020000',
  PENDIN  = octal '0040000',
  TOSTOP  = octal '0100000',
  EXTPROC = octal '0200000',
}

arch.LFLAG.ITOSTOP = arch.LFLAG.TOSTOP

return arch

