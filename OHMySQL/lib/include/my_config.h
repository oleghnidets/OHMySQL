/* Copyright (c) 2009, 2016, Oracle and/or its affiliates. All rights reserved.
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; version 2 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA */

#ifndef MY_CONFIG_H
#define MY_CONFIG_H

/*
 * From configure.cmake, in order of appearance 
 */
#define HAVE_LLVM_LIBCPP 1
#define _LARGEFILE_SOURCE 1

/* Libraries */
/* #undef HAVE_LIBM */
/* #undef HAVE_LIBNSL */
/* #undef HAVE_LIBCRYPT */
/* #undef HAVE_LIBSOCKET */
/* #undef HAVE_LIBDL */
/* #undef HAVE_LIBRT */
/* #undef HAVE_LIBWRAP */

/* Header files */
#define HAVE_ALLOCA_H 1
#define HAVE_ARPA_INET_H 1
#define HAVE_DIRENT_H 1
#define HAVE_DLFCN_H 1
#define HAVE_EXECINFO_H 1
/* #undef HAVE_FPU_CONTROL_H */
#define HAVE_GRP_H 1
/* #undef HAVE_IEEEFP_H */
#define HAVE_LANGINFO_H 1
/* #undef HAVE_MALLOC_H */
#define HAVE_NETINET_IN_H 1
#define HAVE_POLL_H 1
#define HAVE_PWD_H 1
#define HAVE_STRINGS_H 1
#define HAVE_SYS_CDEFS_H 1
#define HAVE_SYS_IOCTL_H 1
#define HAVE_SYS_MMAN_H 1
#define HAVE_SYS_RESOURCE_H 1
#define HAVE_SYS_SELECT_H 1
#define HAVE_SYS_SOCKET_H 1
#define HAVE_TERM_H 1
#define HAVE_TERMIOS_H 1
/* #undef HAVE_TERMIO_H */
#define HAVE_UNISTD_H 1
#define HAVE_SYS_WAIT_H 1
#define HAVE_SYS_PARAM_H 1
#define HAVE_FNMATCH_H 1
#define HAVE_SYS_UN_H 1
#define HAVE_VIS_H 1
#define HAVE_SASL_SASL_H 1

/* Libevent */
/* #undef HAVE_DEVPOLL */
/* #undef HAVE_SYS_DEVPOLL_H */
/* #undef HAVE_SYS_EPOLL_H */
#define HAVE_TAILQFOREACH 1

/* Functions */
/* #undef HAVE_ALIGNED_MALLOC */
#define HAVE_BACKTRACE 1
/* #undef HAVE_PRINTSTACK */
#define HAVE_INDEX 1
/* #undef HAVE_CLOCK_GETTIME */
/* #undef HAVE_CUSERID */
/* #undef HAVE_DIRECTIO */
#define HAVE_FTRUNCATE 1
#define HAVE_COMPRESS 1
#define HAVE_CRYPT 1
#define HAVE_DLOPEN 1
#define HAVE_FCHMOD 1
#define HAVE_FCNTL 1
#define HAVE_FDATASYNC 1
/* #undef HAVE_DECL_FDATASYNC */
/* #undef HAVE_FEDISABLEEXCEPT */
#define HAVE_FSEEKO 1
#define HAVE_FSYNC 1
/* #undef HAVE_GETHOSTBYADDR_R */
/* #undef HAVE_GETHRTIME */
#define HAVE_GETNAMEINFO 1
#define HAVE_GETPASS 1
/* #undef HAVE_GETPASSPHRASE */
#define HAVE_GETPWNAM 1
#define HAVE_GETPWUID 1
#define HAVE_GETRLIMIT 1
#define HAVE_GETRUSAGE 1
#define HAVE_INITGROUPS 1
#define HAVE_ISSETUGID 1
#define HAVE_GETUID 1
#define HAVE_GETEUID 1
#define HAVE_GETGID 1
#define HAVE_GETEGID 1
#define HAVE_LSTAT 1
#define HAVE_MADVISE 1
/* #undef HAVE_MALLOC_INFO */
/* #undef HAVE_MEMRCHR */
#define HAVE_MLOCK 1
#define HAVE_MLOCKALL 1
/* #undef HAVE_MMAP64 */
#define HAVE_POLL 1
/* #undef HAVE_POSIX_FALLOCATE */
#define HAVE_POSIX_MEMALIGN 1
#define HAVE_PREAD 1
/* #undef HAVE_PTHREAD_CONDATTR_SETCLOCK */
#define HAVE_PTHREAD_SIGMASK 1
#define HAVE_READDIR_R 1
#define HAVE_READLINK 1
#define HAVE_REALPATH 1
/* #undef HAVE_SETFD */
#define HAVE_SIGACTION 1
#define HAVE_SLEEP 1
#define HAVE_STPCPY 1
#define HAVE_STPNCPY 1
#define HAVE_STRLCPY 1
#define HAVE_STRNLEN 1
#define HAVE_STRLCAT 1
#define HAVE_STRSIGNAL 1
#define HAVE_FGETLN 1
#define HAVE_STRSEP 1
/* #undef HAVE_TELL */
#define HAVE_VASPRINTF 1
/* #undef HAVE_MEMALIGN */
#define HAVE_NL_LANGINFO 1
/* #undef HAVE_HTONLL */
/* #undef DNS_USE_CPU_CLOCK_FOR_ID */
/* #undef HAVE_EPOLL */
/* #undef HAVE_EVENT_PORTS */
#define HAVE_INET_NTOP 1
#define HAVE_WORKING_KQUEUE 1
#define HAVE_TIMERADD 1
#define HAVE_TIMERCLEAR 1
#define HAVE_TIMERCMP 1
#define HAVE_TIMERISSET 1

/* WL2373 */
#define HAVE_SYS_TIME_H 1
#define HAVE_SYS_TIMES_H 1
#define HAVE_TIMES 1
#define HAVE_GETTIMEOFDAY 1

/* Symbols */
#define HAVE_LRAND48 1
#define GWINSZ_IN_SYS_IOCTL 1
#define FIONREAD_IN_SYS_IOCTL 1
#define FIONREAD_IN_SYS_FILIO 1
/* #undef HAVE_SIGEV_THREAD_ID */
/* #undef HAVE_SIGEV_PORT */
#define HAVE_LOG2 1

#define HAVE_ISINF 1

#define HAVE_KQUEUE_TIMERS 1
/* #undef HAVE_POSIX_TIMERS */

/* Endianess */
/* #undef WORDS_BIGENDIAN */

/* Type sizes */
#define SIZEOF_VOIDP     8
#define SIZEOF_CHARP     8
#define SIZEOF_LONG      8
#define SIZEOF_SHORT     2
#define SIZEOF_INT       4
#define SIZEOF_LONG_LONG 8
#define SIZEOF_OFF_T     8
#define SIZEOF_TIME_T    8
#define HAVE_UINT 1
/* #undef HAVE_ULONG */
#define HAVE_U_INT32_T 1
#define HAVE_STRUCT_TIMESPEC

/* Support for tagging symbols with __attribute__((visibility("hidden"))) */
#define HAVE_VISIBILITY_HIDDEN 1

/* Code tests*/
#define STACK_DIRECTION -1
#define TIME_WITH_SYS_TIME 1
/* #undef NO_FCNTL_NONBLOCK */
#define HAVE_PAUSE_INSTRUCTION 1
/* #undef HAVE_FAKE_PAUSE_INSTRUCTION */
/* #undef HAVE_HMT_PRIORITY_INSTRUCTION */
/* #undef HAVE_ABI_CXA_DEMANGLE */
/* #undef HAVE_BSS_START */
#define HAVE_BUILTIN_UNREACHABLE 1
#define HAVE_BUILTIN_EXPECT 1
#define HAVE_BUILTIN_STPCPY 1
#define HAVE_GCC_ATOMIC_BUILTINS 1
#define HAVE_GCC_SYNC_BUILTINS 1
/* #undef HAVE_VALGRIND */

/* IPV6 */
/* #undef HAVE_NETINET_IN6_H */
#define HAVE_STRUCT_SOCKADDR_IN6 1
#define HAVE_STRUCT_IN6_ADDR 1
#define HAVE_IPV6 1

/* #undef ss_family */
#define HAVE_SOCKADDR_IN_SIN_LEN 1
#define HAVE_SOCKADDR_IN6_SIN6_LEN 1

/*
 * Platform specific CMake files
 */
#define MACHINE_TYPE "x86_64"
/* #undef HAVE_LINUX_LARGE_PAGES */
/* #undef HAVE_SOLARIS_LARGE_PAGES */
/* #undef HAVE_SOLARIS_ATOMIC */
/* #undef HAVE_SOLARIS_STYLE_GETHOST */
#define SYSTEM_TYPE "macos10.12"
/* Windows stuff, mostly functions, that have Posix analogs but named differently */
/* #undef IPPROTO_IPV6 */
/* #undef IPV6_V6ONLY */
/* This should mean case insensitive file system */
/* #undef FN_NO_CASE_SENSE */

/*
 * From main CMakeLists.txt
 */
#define MAX_INDEXES 64U
/* #undef WITH_INNODB_MEMCACHED */
/* #undef ENABLE_MEMCACHED_SASL */
/* #undef ENABLE_MEMCACHED_SASL_PWDB */
#define ENABLED_PROFILING 1
/* #undef HAVE_ASAN */
#define ENABLED_LOCAL_INFILE 1
/* #undef OPTIMIZER_TRACE */
#define DEFAULT_MYSQL_HOME "/usr/local/mysql"
#define SHAREDIR "/usr/local/mysql/share"
#define DEFAULT_BASEDIR "/usr/local/mysql"
#define MYSQL_DATADIR "/usr/local/mysql/data"
#define MYSQL_KEYRINGDIR "/usr/local/mysql/keyring"
#define DEFAULT_CHARSET_HOME "/usr/local/mysql"
#define PLUGINDIR "/usr/local/mysql/lib/plugin"
#define DEFAULT_SYSCONFDIR "/usr/local/mysql/etc"
#define DEFAULT_TMPDIR P_tmpdir
#define INSTALL_SBINDIR "/usr/local/mysql/bin"
#define INSTALL_BINDIR "/usr/local/mysql/bin"
#define INSTALL_MYSQLSHAREDIR "/usr/local/mysql/share"
#define INSTALL_SHAREDIR "/usr/local/mysql/share"
#define INSTALL_PLUGINDIR "/usr/local/mysql/lib/plugin"
#define INSTALL_INCLUDEDIR "/usr/local/mysql/include"
#define INSTALL_SCRIPTDIR "/usr/local/mysql/scripts"
#define INSTALL_MYSQLDATADIR "/usr/local/mysql/data"
#define INSTALL_MYSQLKEYRINGDIR "/usr/local/mysql/keyring"
/* #undef INSTALL_PLUGINTESTDIR */
#define INSTALL_INFODIR "/usr/local/mysql/docs"
#define INSTALL_MYSQLTESTDIR "/usr/local/mysql/mysql-test"
#define INSTALL_DOCREADMEDIR "/usr/local/mysql/."
#define INSTALL_DOCDIR "/usr/local/mysql/docs"
#define INSTALL_MANDIR "/usr/local/mysql/man"
#define INSTALL_SUPPORTFILESDIR "/usr/local/mysql/support-files"
#define INSTALL_LIBDIR "/usr/local/mysql/lib"

/*
 * Readline
 */
/* #undef HAVE_MBSTATE_T */
/* #undef HAVE_LANGINFO_CODESET */
/* #undef HAVE_WCSDUP */
/* #undef HAVE_WCHAR_T */
/* #undef HAVE_WINT_T */
/* #undef HAVE_CURSES_H */
/* #undef HAVE_NCURSES_H */
/* #undef USE_LIBEDIT_INTERFACE */
/* #undef HAVE_HIST_ENTRY */
/* #undef USE_NEW_EDITLINE_INTERFACE */

/*
 * Libedit
 */
/* #undef HAVE_DECL_TGOTO */

/*
 * DTrace
 */
#define HAVE_DTRACE 1

/*
 * Character sets
 */
#define MYSQL_DEFAULT_CHARSET_NAME "latin1"
#define MYSQL_DEFAULT_COLLATION_NAME "latin1_swedish_ci"
#define HAVE_CHARSET_armscii8 1
#define HAVE_CHARSET_ascii 1
#define HAVE_CHARSET_big5 1
#define HAVE_CHARSET_cp1250 1
#define HAVE_CHARSET_cp1251 1
#define HAVE_CHARSET_cp1256 1
#define HAVE_CHARSET_cp1257 1
#define HAVE_CHARSET_cp850 1
#define HAVE_CHARSET_cp852 1 
#define HAVE_CHARSET_cp866 1
#define HAVE_CHARSET_cp932 1
#define HAVE_CHARSET_dec8 1
#define HAVE_CHARSET_eucjpms 1
#define HAVE_CHARSET_euckr 1
#define HAVE_CHARSET_gb2312 1
#define HAVE_CHARSET_gbk 1
#define HAVE_CHARSET_gb18030 1
#define HAVE_CHARSET_geostd8 1
#define HAVE_CHARSET_greek 1
#define HAVE_CHARSET_hebrew 1
#define HAVE_CHARSET_hp8 1
#define HAVE_CHARSET_keybcs2 1
#define HAVE_CHARSET_koi8r 1
#define HAVE_CHARSET_koi8u 1
#define HAVE_CHARSET_latin1 1
#define HAVE_CHARSET_latin2 1
#define HAVE_CHARSET_latin5 1
#define HAVE_CHARSET_latin7 1
#define HAVE_CHARSET_macce 1
#define HAVE_CHARSET_macroman 1
#define HAVE_CHARSET_sjis 1
#define HAVE_CHARSET_swe7 1
#define HAVE_CHARSET_tis620 1
#define HAVE_CHARSET_ucs2 1
#define HAVE_CHARSET_ujis 1
#define HAVE_CHARSET_utf8mb4 1
/* #undef HAVE_CHARSET_utf8mb3 */
#define HAVE_CHARSET_utf8 1
#define HAVE_CHARSET_utf16 1
#define HAVE_CHARSET_utf32 1
#define HAVE_UCA_COLLATIONS 1

/*
 * Feature set
 */
#define WITH_PARTITION_STORAGE_ENGINE 1

/*
 * Performance schema
 */
/* #undef WITH_PERFSCHEMA_STORAGE_ENGINE */
/* #undef DISABLE_PSI_THREAD */
/* #undef DISABLE_PSI_MUTEX */
/* #undef DISABLE_PSI_RWLOCK */
/* #undef DISABLE_PSI_COND */
/* #undef DISABLE_PSI_FILE */
/* #undef DISABLE_PSI_TABLE */
/* #undef DISABLE_PSI_SOCKET */
/* #undef DISABLE_PSI_STAGE */
/* #undef DISABLE_PSI_STATEMENT */
/* #undef DISABLE_PSI_SP */
/* #undef DISABLE_PSI_PS */
/* #undef DISABLE_PSI_IDLE */
/* #undef DISABLE_PSI_STATEMENT_DIGEST */
/* #undef DISABLE_PSI_METADATA */
/* #undef DISABLE_PSI_MEMORY */
/* #undef DISABLE_PSI_TRANSACTION */

/*
 * syscall
*/
/* #undef HAVE_SYS_THREAD_SELFID */
/* #undef HAVE_SYS_GETTID */
/* #undef HAVE_PTHREAD_GETTHREADID_NP */
/* #undef HAVE_PTHREAD_SETNAME_NP */
/* #undef HAVE_INTEGER_PTHREAD_SELF */

/* Platform-specific C++ compiler behaviors we rely upon */

/*
  This macro defines whether the compiler in use needs a 'typename' keyword
  to access the types defined inside a class template, such types are called
  dependent types. Some compilers require it, some others forbid it, and some
  others may work with or without it. For example, GCC requires the 'typename'
  keyword whenever needing to access a type inside a template, but msvc
  forbids it.
 */
/* #undef HAVE_IMPLICIT_DEPENDENT_NAME_TYPING */


/*
 * MySQL version
 */
#define DOT_FRM_VERSION 6
#define MYSQL_VERSION_MAJOR 6
#define MYSQL_VERSION_MINOR 1
#define MYSQL_VERSION_PATCH 9
#define MYSQL_VERSION_EXTRA ""
#define PACKAGE "mysql"
#define PACKAGE_BUGREPORT ""
#define PACKAGE_NAME "MySQL Server"
#define PACKAGE_STRING "MySQL Server 6.1.9"
#define PACKAGE_TARNAME "mysql"
#define PACKAGE_VERSION "6.1.9"
#define VERSION "6.1.9"
#define PROTOCOL_VERSION 10

/*
 * CPU info
 */
#define CPU_LEVEL1_DCACHE_LINESIZE 64

/*
 * NDB
 */
/* #undef WITH_NDBCLUSTER_STORAGE_ENGINE */
/* #undef HAVE_PTHREAD_SETSCHEDPARAM */

/*
 * Other
 */
/* #undef EXTRA_DEBUG */
#define HAVE_CHOWN 1

/*
 * Hardcoded values needed by libevent/NDB/memcached
 */
#define HAVE_FCNTL_H 1
#define HAVE_GETADDRINFO 1
#define HAVE_INTTYPES_H 1
/* libevent's select.c is not Windows compatible */
#ifndef _WIN32
#define HAVE_SELECT 1
#endif
#define HAVE_SIGNAL_H 1
#define HAVE_STDARG_H 1
#define HAVE_STDINT_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRDUP 1
#define HAVE_STRTOK_R 1
#define HAVE_STRTOLL 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_TYPES_H 1
#define SIZEOF_CHAR 1

/*
 * Needed by libevent
 */
/* #undef HAVE_SOCKLEN_T */

/* For --secure-file-priv */
#define DEFAULT_SECURE_FILE_PRIV_DIR "NULL"
#define DEFAULT_SECURE_FILE_PRIV_EMBEDDED_DIR "NULL"
/* #undef HAVE_LIBNUMA */

/* For default value of --early_plugin_load */
/* #undef DEFAULT_EARLY_PLUGIN_LOAD */

#endif
