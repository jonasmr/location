#!/usr/bin/python
import os
import re
import sys
import subprocess
import time
import shlex
# - multiple targets
# - multiple configs
# - multiple platforms
#   .win32 suffix for commands
#   _win32 suffix for dirs & files

cpps = set()
mms = set()
cs = set()
asms = set()
objs = set()
metals = set()
objraw = set()
target = ""
targets = set()
paramz = {};
print("plat " + sys.platform + " os " + os.name)

g_platform = sys.platform
g_win32sdk = ""
g_win32InstallationPath = ""
g_win32VersionPath = ""
g_win32VCVersionNumber = ""
g_win32sdkInclude = ""
g_win32sdkLib = "" 
g_win32CLPath = "";
g_win32LinkPath = "";
g_win32VCPath = ""


paths_processed = set()

def SplitPath(p):
	idx_ext = p.rfind('.')
	idx_path = max(p.rfind('\\'), p.rfind('/'))
	extension_less = p
	extension = ""
	if idx_ext > idx_path:
		extension_less = p[:idx_ext];
		extension = p[idx_ext+1:];
	idx_platform = extension_less.rfind('_')
	platform = ""
	if idx_platform > idx_path:
		platform = extension_less[idx_platform+1:]
	#print( "Base '%s' :: extension '%s' platform '%s' debug '%s' " % (p, extension, platform, extension_less) )
	return extension, platform;

def SplitCommand(c):
	idx_platform = c.rfind('.');
	platform = ""
	command = c
	if idx_platform > 0:
		platform = c[idx_platform+1:]
		command = c[:idx_platform];
	#print("Split Command '%s' :: c '%s' plat '%s'" % (c, command, platform))
	return command, platform;


def PlatformMatch(p):
	return p == "" or p == g_platform

SplitPath("//food/sdf\\fisk_win32")
SplitPath("//food/sdf\\fisk.txt")
SplitPath("//food/sdf\\fisk_win32.txt")
SplitCommand(".fisk")
SplitCommand(".fisk.osx")
SplitCommand(".fisk.win32sd")
SplitCommand(".fisk.linux")


def RunVSWhere():
	Result = {}
	if g_platform == "win32":
		ProgramFilesx84 = os.getenv("ProgramFiles(x86)");
		Path = "\"%s\\Microsoft Visual Studio\\Installer\\vswhere.exe\" -version 15" % (ProgramFilesx84);
		print(shlex.split(Path))
		Process = subprocess.Popen(args=shlex.split(Path), stdout=subprocess.PIPE)
		Process.wait()
		out, err = Process.communicate()
		lines = out.splitlines()
		# Process = subprocess.run(Path, stdout=subprocess.PIPE, text=True)
		# lines = Process.stdout.split("\n")
		for line in lines:
			l = line.decode('utf-8')
			print("Line " + l)
			l = l.strip()
			idx = l.find(":")
			if idx > 0:
				key = l[:idx]
				value = l[idx+2:]
				Result[key] = value
	return Result;

g_vswhere = RunVSWhere()
if g_platform == "win32":
	g_win32InstallationPath = g_vswhere["installationPath"]
	g_win32VersionPath = "%s\\VC\\Auxiliary\\Build\\Microsoft.VCToolsVersion.default.txt" % g_win32InstallationPath
	with open(g_win32VersionPath) as f:
		g_win32VCVersionNumber = ''.join(f.read().split())

g_win32CLPath = "%s\\VC\\Tools\\MSVC\\%s\\bin\\HostX64\\x64\\cl.exe" % (g_win32InstallationPath, g_win32VCVersionNumber)
g_win32LinkPath = "%s\\VC\\Tools\\MSVC\\%s\\bin\\HostX64\\x64\\link.exe" % (g_win32InstallationPath, g_win32VCVersionNumber)
g_win32VCPath = "%s\\VC\\Tools\\MSVC\\%s" % (g_win32InstallationPath, g_win32VCVersionNumber)


def ProcessPath(d):
	abspth = os.path.abspath(d)
	extension, platform = SplitPath(abspth)
	if PlatformMatch(platform):
		print("Process Path " + abspth)
		if not abspth in paths_processed:
			paths_processed.add(abspth)
			for filename in os.listdir(abspth):
				p = os.path.join(d, filename)
				extension, platform = SplitPath(p)
				if PlatformMatch(platform):
					if extension == "cpp":
						cpps.add(p)
						print("cpp " + p)
					if extension == "mm":
						mms.add(p)
						print("mm " + p)
					if extension == "metal":
						metals.add(p)
						print("metal " + p)
					if extension == "s":
						asms.add(p)
						print("asm " + p)


def fixname(name, ext):
	rawbase = os.path.basename(name)[:-len(ext)]
	raw = rawbase
	idx = 0
	while raw in objraw:
		raw = "%s_%d" %(rawbase, idx)
		idx = idx + 1
	objraw.add(raw)
	objname = "$builddir/" + raw
	return objname, name

def AddParam(Param, V):
	print("--> '" + Param + "' '" + V +"'")
	value = paramz.get(Param, "");
	l1 = value
	value = value + " " + V;
	paramz[Param] = value;
	



with open("ngen.cfg") as f:
	for line in f:
		line = line.strip()
		if len(line) > 0 and line[0] != '#':
			if(line[0] == '.'):
				command = line[1:].strip()
				idx = command.find(' ')
				arg = command[idx+1:].strip()
				command = command[:idx]
				print("COMMAND!! " + command)
				if command == "win32sdk":
					if g_platform == "win32":
						g_win32sdk = arg
						print("win32 SDK: " + g_win32sdk)
				if(command == "dir"):
					ProcessPath(arg)
				if(command == "target"):
					target = arg.strip()
					if g_platform == "win32":
						target = target + ".exe"
					targets.add(target)
			else:
				idx = re.search(r'[ =]', line).start()
				i = line.find('=')
				if i > 0:
					l0 = line[:i].strip()
					l1 = line[i+1:].strip()
					l0, platform = SplitCommand(l0)					
					if PlatformMatch(platform):
						AddParam(l0, l1);


if g_win32sdk != "":
	g_win32sdkInclude = "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\%s" % g_win32sdk
	g_win32sdkLib = "C:\\Program Files (x86)\\Windows Kits\\10\\Lib\\%s" % g_win32sdk
	AddParam("cflags", "-I\"%s\\include\"" % g_win32VCPath)
	AddParam("cflags", "-I\"%s\\atlmfc\\include\"" % g_win32VCPath)
	AddParam("cflags", "-I\"%s\\ucrt\"" % g_win32sdkInclude)
	AddParam("cflags", "-I\"%s\\um\"" % g_win32sdkInclude)
	AddParam("cflags", "-I\"%s\\shared\"" % g_win32sdkInclude)
	AddParam("ldflags", "/LIBPATH:\"%s\\ucrt\\x64\"" % g_win32sdkLib);
	AddParam("ldflags", "/LIBPATH:\"%s\\um\\x64\"" % g_win32sdkLib);
	AddParam("ldflags", "/LIBPATH:\"%s\\lib\\x64\"" % g_win32VCPath)

with open("build.ninja", "w") as f:
	if g_platform == "win32":
		f.write("cxx = " + g_win32CLPath + "\n")
	else:
		f.write("cxx = clang++\n")
	
	if g_platform == "win32":
		f.write("link = " + g_win32LinkPath + "\n")

	for key,value in paramz.items():
		f.write( "%s = %s\n\n" % (key.strip(), value.strip()))
		print( "%s = %s" % (key.strip(), value.strip()))

	if g_platform == "osx":
		f.write("""rule cxx
  command = $cxx -MMD -MT $out -MF $out.d $cflags -c $in -o $out
  description = CXX $out
  depfile = $out.d
  deps = gcc

""")

		f.write("""rule asm
  command = as -masm=intel $in -o $out
  description = ASM $out

""")

		f.write("""rule mxx
  command = $cxx -MMD -MT $out -MF $out.d $cflags $mmflags -c $in -o $out
  description = CXX $out
  depfile = $out.d
  deps = gcc

""")

		f.write("""rule link
  command = $cxx $ldflags -o $out $in $libs
  description = LINK $out

""")
		f.write("""rule metal
  command = xcrun -sdk macosx metal $in -o $out 
  description = METAL $out

""")

		f.write("""rule metallib
  command = xcrun -sdk macosx metallib $in -o $out 
  description = METAL $out

""")
	elif g_platform == "win32":
		f.write("""rule cxx
  command = $cxx /showIncludes /c $in /Fo$out $cflags
  description = CXX $out
  depfile = $out.d
  deps = msvc

""")
		f.write("""rule link
  command = $link $ldflags /OUT:$out $in $libs
  description = LINK $out

""")

	f.write("""rule ngen
  command = python ngen.py

""")


	for v in cpps:
		objname, fullname = fixname(v, ".cpp")
		objs.add(objname+".o")
		f.write("build %s: cxx %s\n" % (objname+".o", fullname))
	for v in mms:
		objname, fullname = fixname(v, ".mm")
		objs.add(objname+".o")
		f.write("build %s: mxx %s\n" % (objname+".o", fullname))

	for v in asms:
		objname, fullname = fixname(v, ".s")
		objs.add(objname+".o")
		f.write("build %s: asm %s\n" % (objname+".o", fullname))

	for v in metals:
		objname, fullname = fixname(v, ".metal")
		f.write("build %s: metal %s\n" % (objname+".air", fullname))
		f.write("build %s: metallib %s\n" % (objname+".metallib", objname+".air"))
		targets.add(objname+".metallib")


	f.write("build %s: link" %(target))
	for obj in objs:
		f.write(" " + obj)
	f.write("\n\n")

	f.write("build build.ninja: ngen ngen.cfg\n\n");


	f.write("default build.ninja " );
	for s in targets:
		f.write(" " + s)
	f.write("\n\n")




