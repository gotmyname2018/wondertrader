-- xmake.lua for WonderTrader Project
-- Compatible with Xmake 3.0.1

set_project("WonderTrader")

-- Set minimum xmake version
set_xmakever("3.0.1")

-- Set C++ standard
set_languages("c++17")

-- Add build modes
add_rules("mode.debug", "mode.release")

-- Use system-preinstalled headers/libs from /home/mydeps (see below)

-- Prefer setting dependency search paths as early as possible
if is_plat("linux") then
    -- Try environment first, then common fallback paths
    local candidates = { os.getenv("MyDependsGcc"), "/home/mydeps", "/home/mydeps" }
    for _, root in ipairs(candidates) do
        if root and root ~= "" and os.isdir(root) then
            add_includedirs(path.join(root, "include"))
            add_linkdirs(path.join(root, "lib"))
            add_rpathdirs(path.join(root, "lib"))
            break
        end
    end
    -- Default link libs to match CMakeLists usage across targets
    add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
end

-- Platform and toolchain configuration
if is_plat("windows") then
    add_defines("_CRT_SECURE_NO_WARNINGS")
    -- Environment variables for dependencies
    local mydeps = os.getenv("MyDepends141")
    if mydeps then
        add_includedirs(path.join(mydeps, "include"))
        if is_arch("x64") then
            add_linkdirs(path.join(mydeps, "lib/x64"))
        else
            add_linkdirs(path.join(mydeps, "lib/x86"))
        end
    end
elseif is_plat("linux") then
    add_cxflags("-fPIC")
    add_cflags("-fPIC")
    
    -- Dependencies path for Linux
    local mydeps = os.getenv("MyDependsGcc")
    if mydeps then
        add_includedirs(path.join(mydeps, "include"))
        add_linkdirs(path.join(mydeps, "lib"))
    else
        add_includedirs("/home/mydeps/include")
        add_linkdirs("/home/mydeps/lib")
    end
end

-- Output directories
set_objectdir("$(builddir)/$(plat)/$(arch)/$(mode)/obj")

-- Basic utility libraries
target("WTSUtils")
    set_kind("static")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/libs")
    add_files("WTSUtils/*.cpp", "WTSUtils/zstdlib/*.c", "WTSUtils/yamlcpp/*.cpp", "WTSUtils/lmdb/*.c")
    add_headerfiles("WTSUtils/*.h", "WTSUtils/zstdlib/*.h")
    add_includedirs("WTSUtils/yamlcpp")
    
    if is_plat("windows") then
        add_files("WTSUtils/StackTracer/StackTracer.cpp", "WTSUtils/StackTracer/StackWalker.cpp")
    else
        add_files("WTSUtils/StackTracer/StackTracer.cpp")
    end

target("WTSTools")
    set_kind("static")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/libs")
    add_files("WTSTools/*.cpp")
    add_headerfiles("WTSTools/*.h")
    add_deps("WTSUtils")


-- Core libraries
target("WtCore")
    set_kind("static")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/libs")
    add_files("WtCore/*.cpp")
    add_headerfiles("WtCore/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtBtCore")
    set_kind("static")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/libs")
    add_files("WtBtCore/*.cpp")
    add_headerfiles("WtBtCore/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtUftCore")
    set_kind("static")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/libs")
    add_files("WtUftCore/*.cpp")
    add_headerfiles("WtUftCore/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtDtCore")
    set_kind("static")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/libs")
    add_files("WtDtCore/*.cpp")
    add_headerfiles("WtDtCore/*.h")
    add_deps("WTSUtils", "WTSTools")

-- Data storage
target("WtDataStorage")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtDataStorage/*.cpp")
    add_headerfiles("WtDataStorage/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtDataStorageAD")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtDataStorageAD/*.cpp")
    add_headerfiles("WtDataStorageAD/*.h")
    add_deps("WTSUtils", "WTSTools")

-- Parsers
target("ParserCTP")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserCTP/*.cpp")
    add_headerfiles("ParserCTP/*.h")
    add_deps("WTSUtils", "WTSTools")

target("ParserCTPMini")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserCTPMini/*.cpp")
    add_headerfiles("ParserCTPMini/*.h")
    add_deps("WTSUtils", "WTSTools")

target("ParserCTPOpt")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserCTPOpt/*.cpp")
    add_headerfiles("ParserCTPOpt/*.h")
    add_deps("WTSUtils", "WTSTools")

target("ParserFemas")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserFemas/*.cpp")
    add_headerfiles("ParserFemas/*.h")
    add_deps("WTSUtils", "WTSTools")

target("ParserXTP")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserXTP/*.cpp")
    add_headerfiles("ParserXTP/*.h")
    add_deps("WTSUtils", "WTSTools")

target("ParserShm")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserShm/*.cpp")
    add_headerfiles("ParserShm/*.h")
    add_deps("WTSUtils", "WTSTools")

target("ParserXeleSkt")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserXeleSkt/*.cpp")
    add_headerfiles("ParserXeleSkt/*.h")
    add_deps("WTSUtils", "WTSTools")

target("ParserUDP")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserUDP/*.cpp")
    add_headerfiles("ParserUDP/*.h")
    add_deps("WTSUtils", "WTSTools")

target("ParserYD")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("ParserYD/*.cpp")
    add_headerfiles("ParserYD/*.h")
    add_deps("WTSUtils", "WTSTools")

-- Traders
target("TraderCTP")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderCTP/*.cpp")
    add_headerfiles("TraderCTP/*.h")
    add_deps("WTSUtils", "WTSTools")

target("TraderCTPMini")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderCTPMini/*.cpp")
    add_headerfiles("TraderCTPMini/*.h")
    add_deps("WTSUtils", "WTSTools")

target("TraderCTPOpt")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderCTPOpt/*.cpp")
    add_headerfiles("TraderCTPOpt/*.h")
    add_deps("WTSUtils", "WTSTools")

target("TraderFemas")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderFemas/*.cpp")
    add_headerfiles("TraderFemas/*.h")
    add_deps("WTSUtils", "WTSTools")

target("TraderMocker")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderMocker/*.cpp")
    add_headerfiles("TraderMocker/*.h")
    add_deps("WTSUtils", "WTSTools")

target("TraderXTP")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderXTP/*.cpp")
    add_headerfiles("TraderXTP/*.h")
    add_deps("WTSUtils", "WTSTools")

target("TraderYD")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderYD/*.cpp")
    add_headerfiles("TraderYD/*.h")
    add_deps("WTSUtils", "WTSTools")

target("TraderDumper")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderDumper/*.cpp")
    add_headerfiles("TraderDumper/*.h")
    add_deps("WTSUtils", "WTSTools")


target("TraderOES")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderOES/*.cpp")
    add_headerfiles("TraderOES/*.h")
    add_deps("WTSUtils", "WTSTools")
    add_includedirs("$(projectdir)/API/oesApi0.17.5.8/include")
    add_linkdirs("$(projectdir)/API/oesApi0.17.5.8/linux")
    add_links("liboes_api.a")  -- 尝试可能的库名
    add_syslinks("pthread", "dl")

target("TraderXTPXAlgo")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TraderXTPXAlgo/*.cpp")
    add_headerfiles("TraderXTPXAlgo/*.h")
    add_deps("WTSUtils", "WTSTools")

-- Loaders
target("CTPLoader")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("CTPLoader/*.cpp")
    add_headerfiles("CTPLoader/*.h")
    add_deps("WTSUtils", "WTSTools")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
    end

target("CTPOptLoader")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("CTPOptLoader/*.cpp")
    add_headerfiles("CTPOptLoader/*.h")
    add_deps("WTSUtils", "WTSTools")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
    end

-- Factories
target("WtExeFact")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtExeFact/*.cpp")
    add_headerfiles("WtExeFact/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtRiskMonFact")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtRiskMonFact/*.cpp")
    add_headerfiles("WtRiskMonFact/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtCtaStraFact")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtCtaStraFact/*.cpp")
    add_headerfiles("WtCtaStraFact/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtHftStraFact")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtHftStraFact/*.cpp")
    add_headerfiles("WtHftStraFact/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtUftStraFact")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtUftStraFact/*.cpp")
    add_headerfiles("WtUftStraFact/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtSelStraFact")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtSelStraFact/*.cpp")
    add_headerfiles("WtSelStraFact/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtIndexFactory")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtIndexFactory/*.cpp")
    add_headerfiles("WtIndexFactory/*.h")
    add_deps("WTSUtils", "WTSTools")

-- Helpers and utilities
target("WtDtHelper")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtDtHelper/*.cpp")
    add_headerfiles("WtDtHelper/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtShareHelper")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtShareHelper/*.cpp")
    add_headerfiles("WtShareHelper/*.h")
    add_deps("WTSUtils", "WTSTools")

target("WtMsgQue")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtMsgQue/*.cpp")
    add_headerfiles("WtMsgQue/*.h")
    add_deps("WTSUtils", "WTSTools")
    if is_plat("linux") then
        add_links("nanomsg")
    end

-- Porters (C interface libraries)
target("WtPorter")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtPorter/*.cpp")
    add_headerfiles("WtPorter/*.h")
    add_deps("WtCore", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
        set_symbols("hidden")
    end

target("WtBtPorter")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtBtPorter/*.cpp")
    add_headerfiles("WtBtPorter/*.h")
    add_deps("WtBtCore", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
    else
        add_links("dl", "pthread", "stdc++fs", "boost_filesystem", "boost_thread")
        if is_plat("mingw") then
            add_links("iconv")
        end
        add_ldflags("-s")
        set_symbols("hidden")
    end

target("WtDtPorter")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtDtPorter/*.cpp")
    add_headerfiles("WtDtPorter/*.h")
    add_deps("WtDtCore", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
    else
        add_links("dl", "pthread", "stdc++fs", "boost_filesystem", "boost_thread")
        if is_plat("mingw") then
            add_links("iconv")
        end
        add_ldflags("-s")
        set_symbols("hidden")
    end

-- Servos
target("WtDtServo")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtDtServo/*.cpp")
    add_headerfiles("WtDtServo/*.h")
    add_deps("WtDtCore", "WTSTools", "WTSUtils")

target("WtExecMon")
    set_kind("shared")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtExecMon/*.cpp")
    add_headerfiles("WtExecMon/*.h")
    add_deps("WtCore", "WTSTools", "WTSUtils")

-- Executables
target("LoaderRunner")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("LoaderRunner/*.cpp")
    add_deps("WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

target("QuoteFactory")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("QuoteFactory/*.cpp")
    add_deps("WTSTools", "WTSUtils", "WtDtCore")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
        add_links("ws2_32")
    else
        add_links("dl", "boost_filesystem", "boost_thread", "pthread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end
    -- Post-build actions to copy parsers
    after_build(function (target)
        local outputdir = target:targetdir()
        local parsersdir = path.join(outputdir, "parsers")
        os.mkdir(parsersdir)
        
        local bindir = "$(builddir)/$(plat)/$(arch)/$(mode)/bin"
        local prefix = is_plat("windows") and "" or "lib"
        local suffix = is_plat("windows") and ".dll" or ".so"
        
        -- Copy parser modules
        local parsers = {"ParserCTP", "ParserXTP", "ParserFemas", "ParserCTPMini"}
        for _, parser in ipairs(parsers) do
            local srcfile = path.join(bindir, prefix .. parser .. suffix)
            local dstfile = path.join(parsersdir, prefix .. parser .. suffix)
            os.cp(srcfile, dstfile)
        end
        
        -- Copy WtDataStorage
        local srcfile = path.join(bindir, prefix .. "WtDataStorage" .. suffix)
        local dstfile = path.join(outputdir, prefix .. "WtDataStorage" .. suffix)
        os.cp(srcfile, dstfile)
    end)

target("WtBtRunner")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtBtRunner/*.cpp")
    add_deps("WtBtCore", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

target("WtRunner")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtRunner/*.cpp")
    add_deps("WtCore", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end
    -- Post-build actions to copy modules
    after_build(function (target)
        local outputdir = target:targetdir()
        local parsersdir = path.join(outputdir, "parsers")
        local tradersdir = path.join(outputdir, "traders")
        local executerdir = path.join(outputdir, "executer")
        
        os.mkdir(parsersdir)
        os.mkdir(tradersdir)
        os.mkdir(executerdir)
        
        local bindir = "$(builddir)/$(plat)/$(arch)/$(mode)/bin"
        local prefix = is_plat("windows") and "" or "lib"
        local suffix = is_plat("windows") and ".dll" or ".so"
        
        -- Copy parser modules
        local srcfile = path.join(bindir, prefix .. "ParserUDP" .. suffix)
        local dstfile = path.join(parsersdir, prefix .. "ParserUDP" .. suffix)
        os.cp(srcfile, dstfile)
        
        -- Copy trader modules
        local traders = {"TraderCTP", "TraderXTP", "TraderMocker", "TraderCTPMini", "TraderCTPOpt"}
        for _, trader in ipairs(traders) do
            local srcfile = path.join(bindir, prefix .. trader .. suffix)
            local dstfile = path.join(tradersdir, prefix .. trader .. suffix)
            os.cp(srcfile, dstfile)
        end
    end)

target("WtUftRunner")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtUftRunner/*.cpp")
    add_deps("WtUftCore", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end
    -- Post-build actions to copy modules
    after_build(function (target)
        local outputdir = target:targetdir()
        local parsersdir = path.join(outputdir, "parsers")
        local tradersdir = path.join(outputdir, "traders")
        
        os.mkdir(parsersdir)
        os.mkdir(tradersdir)
        
        local bindir = "$(builddir)/$(plat)/$(arch)/$(mode)/bin"
        local prefix = is_plat("windows") and "" or "lib"
        local suffix = is_plat("windows") and ".dll" or ".so"
        
        -- Copy TraderCTP
        local srcfile = path.join(bindir, prefix .. "TraderCTP" .. suffix)
        local dstfile = path.join(tradersdir, prefix .. "TraderCTP" .. suffix)
        os.cp(srcfile, dstfile)
        
        -- Copy ParserCTP
        local srcfile = path.join(bindir, prefix .. "ParserCTP" .. suffix)
        local dstfile = path.join(parsersdir, prefix .. "ParserCTP" .. suffix)
        os.cp(srcfile, dstfile)
    end)

target("WtLatencyHFT")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtLatencyHFT/*.cpp")
    add_deps("WtCore", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_thread", "boost_filesystem", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

target("WtLatencyUFT")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("WtLatencyUFT/*.cpp")
    add_deps("WtUftCore", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_files("Common/mdump.cpp")
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_thread", "boost_filesystem", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

-- Test projects
target("TestBtPorter")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TestBtPorter/*.cpp")
    add_deps("WtBtPorter", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

target("TestDtPorter")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TestDtPorter/*.cpp")
    add_deps("WtDtPorter", "WtDtHelper", "WTSTools", "WTSUtils", "ParserUDP")
    add_syslinks("pthread", "dl", "m")
    add_ldflags("-Wl,-rpath=./")

target("TestExecPorter")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TestExecPorter/*.cpp")
    
    -- 添加所有依赖库（包括WtPorter和WtExecMon）
    add_deps("WtPorter", "WtExecMon", "WTSTools", "WTSUtils")
    
    -- 平台特定的链接配置
    if is_plat("windows") then
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

target("TestPorter")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TestPorter/*.cpp")
    add_deps("WtPorter", "WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

target("TestTrader")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TestTrader/*.cpp")
    add_deps("WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_links("ws2_32")
    else
        add_links("dl", "pthread", "boost_filesystem", "boost_thread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

target("TestParser")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    add_files("TestParser/*.cpp")
    add_deps("WTSTools", "WTSUtils")
    if is_plat("windows") then
        add_links("ws2_32")
    else
        add_packages("boost")
        add_links("dl", "pthread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end

target("TestUnits")
    set_kind("binary")
    set_targetdir("$(builddir)/$(plat)/$(arch)/$(mode)/bin")
    
    -- 添加源文件（包括gtest文件）
    add_files("TestUnits/*.cpp", "TestUnits/gtest/*.cc")
    add_headerfiles("TestUnits/*.h", "TestUnits/gtest/*.h")
    
    -- 添加依赖库
    add_deps("WtPorter", "WTSTools", "WTSUtils", "WtShareHelper")
    
    -- 添加包含目录（包括gtest目录）
    add_includedirs("TestUnits/gtest")
    
    -- 平台特定的链接配置
    if is_plat("windows") then
        add_links("ws2_32")
    else
        add_packages("boost")
        add_links("dl", "pthread", "stdc++fs")
        if is_plat("mingw") then
            add_links("ws2_32", "iconv")
        end
        add_ldflags("-s")
    end
    
    -- 添加gtest相关配置
    add_defines("GTEST_HAS_PTHREAD=1")
    if is_plat("linux") then
        add_defines("GTEST_OS_LINUX=1")
    elseif is_plat("windows") then
        add_defines("GTEST_OS_WINDOWS=1")
    end
