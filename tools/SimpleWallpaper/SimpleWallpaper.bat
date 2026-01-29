@echo off & chcp 65001>nul & setlocal EnableDelayedExpansion
net session >nul 2>&1 || (echo 请以管理员身份运行 & pause>nul)

:: 初始化一些必要参数 
set "appName=SimpleWallpaper"
set "appNameCN=简单壁纸"
set "installDir=%LOCALAPPDATA%\%appName%"
set "configFile=%installDir%\smw_config.ini"
set "vbsPath=%installDir%\%appName%.vbs"
set "requiredParams=smw_wallpaperPath smw_auto_change smw_day_bing_wallpaper smw_log"
set "app_regedit=HKCR\DesktopBackground\shell\wallpaper"
set "autoChangeTaskName=自动更换背景"
set "dayBingWallpaperTaskName=必应每日一图"

:: 手动运行/右键运行 
for %%i in (%*) do (set /a PIndex+=1 & call set "param[!PIndex!]=%%~i")
if not defined param[1] (goto :human_menu) else (goto :cmd_menu)

:human_menu
mode con cols=90 lines=35 & color 0A & title 右键%appNameCN% v1.6
set "c=" &echo.&echo.&echo.
echo					    右键%appNameCN%	&echo.&echo.&echo.
echo				1. 安装      2. 卸载      0.退出&echo.&echo.&echo.   
set /p c=请输入你的选择: 
if "%c%"=="1"  call :install
if "%c%"=="2"  call :uninstall
if "%c%"=="0" exit
goto human_menu 

:cmd_menu
call :init_app
call :print_log "执行命令：%param[1]%"
if "%param[1]%"=="prev" call :choose_wallpaper
if "%param[1]%"=="next" call :choose_wallpaper
if "%param[1]%"=="rand" call :choose_wallpaper
if "%param[1]%"=="latest" call :choose_wallpaper
if "%param[1]%"=="uninstall" call :uninstall
if "%param[1]%"=="auto" call :auto
if "%param[1]%"=="set_wallpaperPath" call :set_wallpaperPath
if "%param[1]%"=="open_wallpaperPath" call :open_wallpaperPath
if "%param[1]%"=="open_installDir" call :open_installDir
if "%param[1]%"=="load_bing_wallpaper" call :load_bing_wallpaper
if "%param[1]%"=="day_bing_wallpaper" call :day_bing_wallpaper
if "%param[1]%"=="toggle_auto_change" call :toggle_auto_change
call :print_log "---------end---------"
exit

:init_app
for /f "usebackq eol=# tokens=1,* delims==" %%a in (%configFile%) do set "%%a=%%b"
call :print_log "---------start---------"
call :print_log "加载配置文件..."
for %%p in (%requiredParams%) do (if not defined %%p (call :print_log 缺少参数%%p & exit) else (set "tv=!%%p!" & call :print_log "%%p=!tv!"))
for /f "tokens=1,2,*" %%a in ('reg query "HKCU\Control Panel\Desktop" /v Wallpaper ^| findstr /i "Wallpaper"') do (
	set "current_wallpaper=%%~c"
	call :print_log "当前壁纸路径: !current_wallpaper!"
)
exit /b

:install
if not exist "%installDir%" mkdir "%installDir%"
if not exist "%installDir%\log" mkdir "%installDir%\log"
:: 设置壁纸下载位置 
for /f "usebackq delims=" %%P in (`powershell -nologo -noprofile -command "[Environment]::GetFolderPath('MyPictures')"`) do (
	set "smw_wallpaperPath=%%P\%appName%"
)
:: 必应每日一图 0关闭 1开启 
set "smw_day_bing_wallpaper=0"
:: 自动换图 0关闭 1开启 
set "smw_auto_change=0"
:: 日志记录 0关闭 1开启 
set "smw_log=0"
call :save_config
copy /y "%~f0" "%installDir%\%appName%.bat" >nul
(	echo Set shell = CreateObject("Shell.Application"^)
	echo Set fso = CreateObject("Scripting.FileSystemObject"^)
	echo scriptDir = fso.GetParentFolderName(WScript.ScriptFullName^)
	echo args = ""
	echo For i = 0 To WScript.Arguments.Count - 1
	echo     args = args ^& " " ^& Chr(34^) ^& WScript.Arguments(i^) ^& Chr(34^)
	echo Next
	echo shell.ShellExecute "cmd.exe", "/c cd /d """ ^& scriptDir ^& """ && %appName%.bat" ^& args, "", "runas", 0
) > "%vbsPath%"
call :print_log "安装%appNameCN% start"
reg add "%app_regedit%" /v "MUIVerb" /t REG_SZ /d "%appNameCN%" /f >nul 2>&1
reg add "%app_regedit%" /v "Icon" /t REG_SZ /d "imageres.dll,-113" /f >nul 2>&1
reg add "%app_regedit%" /v "SubCommands" /t REG_SZ /d "" /f >nul 2>&1
reg add "%app_regedit%\shell\1_pre" /v "MUIVerb" /t REG_SZ /d "上一张" /f >nul 2>&1
reg add "%app_regedit%\shell\1_pre" /v "Icon" /t REG_SZ /d "shell32.dll,-16749" /f >nul 2>&1
reg add "%app_regedit%\shell\1_pre\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" prev" /f >nul 2>&1
reg add "%app_regedit%\shell\2_next" /v "MUIVerb" /t REG_SZ /d "下一张" /f >nul 2>&1
reg add "%app_regedit%\shell\2_next" /v "Icon" /t REG_SZ /d "shell32.dll,-16750" /f >nul 2>&1
reg add "%app_regedit%\shell\2_next\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" next" /f >nul 2>&1
reg add "%app_regedit%\shell\3_latest" /v "MUIVerb" /t REG_SZ /d "最新" /f >nul 2>&1
reg add "%app_regedit%\shell\3_latest" /v "Icon" /t REG_SZ /d "imageres.dll,-5100" /f >nul 2>&1
reg add "%app_regedit%\shell\3_latest\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" latest" /f >nul 2>&1
reg add "%app_regedit%\shell\4_random" /v "MUIVerb" /t REG_SZ /d "随机" /f >nul 2>&1
reg add "%app_regedit%\shell\4_random" /v "Icon" /t REG_SZ /d "imageres.dll,-1401" /f >nul 2>&1
reg add "%app_regedit%\shell\4_random\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" rand" /f >nul 2>&1
reg add "%app_regedit%\shell\5_autoChange" /v "MUIVerb" /t REG_SZ /d "自动更换" /f >nul 2>&1
reg add "%app_regedit%\shell\5_autoChange\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" toggle_auto_change" /f >nul 2>&1
reg add "%app_regedit%\shell\6_0network" /v CommandFlags /t REG_DWORD /d 0x00000008 /f >nul 2>&1
reg add "%app_regedit%\shell\6_network" /v "MUIVerb" /t REG_SZ /d "联网壁纸" /f >nul 2>&1
reg add "%app_regedit%\shell\6_network" /v "Icon" /t REG_SZ /d "imageres.dll,-1404" /f >nul 2>&1 
reg add "%app_regedit%\shell\6_network" /v "SubCommands" /t REG_SZ /d "" /f >nul 2>&1
reg add "%app_regedit%\shell\6_network\shell\1_bingWallpaper" /v "MUIVerb" /t REG_SZ /d "下载必应壁纸" /f >nul 2>&1
reg add "%app_regedit%\shell\6_network\shell\1_bingWallpaper" /v "Icon" /t REG_SZ /d "imageres.dll,-184" /f >nul 2>&1
reg add "%app_regedit%\shell\6_network\shell\1_bingWallpaper\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" load_bing_wallpaper" /f >nul 2>&1
reg add "%app_regedit%\shell\6_network\shell\2_bingDayWallpaper" /v "MUIVerb" /t REG_SZ /d "必应每日一图" /f >nul 2>&1
reg add "%app_regedit%\shell\6_network\shell\2_bingDayWallpaper\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" day_bing_wallpaper" /f >nul 2>&1
reg add "%app_regedit%\shell\7_0setting" /v CommandFlags /t REG_DWORD /d 0x00000008 /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting" /v "MUIVerb" /t REG_SZ /d "设置" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting" /v "Icon" /t REG_SZ /d "shell32.dll,-16826" /f >nul 2>&1 
reg add "%app_regedit%\shell\7_setting" /v "SubCommands" /t REG_SZ /d "" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\1_wallpaperPath" /v "MUIVerb" /t REG_SZ /d "设置壁纸目录" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\1_wallpaperPath" /v "Icon" /t REG_SZ /d "shell32.dll,-46" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\1_wallpaperPath\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" set_wallpaperPath" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\2_openWallpaperPath" /v "MUIVerb" /t REG_SZ /d "打开壁纸目录" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\2_openWallpaperPath" /v "Icon" /t REG_SZ /d "shell32.dll,-37" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\2_openWallpaperPath\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" open_wallpaperPath" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\3_openInstallDir" /v "MUIVerb" /t REG_SZ /d "打开应用目录" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\3_openInstallDir" /v "Icon" /t REG_SZ /d "shell32.dll,-264" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\3_openInstallDir\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" open_installDir" /f >nul 2>&1
if "%smw_log%"=="1" (
	reg add "%app_regedit%\shell\7_setting\shell\4_cleanlog" /v "MUIVerb" /t REG_SZ /d "清理日志" /f >nul 2>&1
	reg add "%app_regedit%\shell\7_setting\shell\4_cleanlog" /v "Icon" /t REG_SZ /d "shell32.dll,-261" /f >nul 2>&1
	reg add "%app_regedit%\shell\7_setting\shell\4_cleanlog\command" /ve /t REG_SZ /d "cmd.exe /c del /F /Q \"%installDir%\\log\\smw.log\"" /f >nul 2>&1
)
reg add "%app_regedit%\shell\7_setting\shell\5_uninstall" /v "MUIVerb" /t REG_SZ /d "卸载" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\5_uninstall" /v "Icon" /t REG_SZ /d "shell32.dll,-32" /f >nul 2>&1
reg add "%app_regedit%\shell\7_setting\shell\5_uninstall\command" /ve /t REG_SZ /d "wscript.exe \"\"%vbsPath%\"\" uninstall" /f >nul 2>&1
call :print_log "安装%appNameCN% end"
echo.&echo.
echo.&echo  安装成功，默认安装位置：%installDir%
echo.&echo  请在桌面空白处右键%appNameCN%，设置壁纸目录后使用！ 
echo.&echo  该文件已拷贝至安装目录下，因此不用刻意保留，除非你有别的用途。 
echo. & pause & exit /b

:uninstall
set "uninstall_script=%TEMP%\uninstall_script.bat"
(
	echo @echo off
	echo cd /d "%%TEMP%%"
	echo reg delete "%app_regedit%" /f ^>nul 2^>nul
	echo rd /s /q "%installDir%" ^>nul 2^>nul
	echo schtasks /delete /tn "%autoChangeTaskName%" /F ^>nul 2^>nul
	echo schtasks /delete /tn "%dayBingWallpaperTaskName%" /F ^>nul 2^>nul
	echo del /F /Q "%%~f0" ^>nul 2^>nul
) > "%uninstall_script%"
start "" /B cmd /c call "%uninstall_script%" & exit

:choose_wallpaper
set "direction=%param[1]%"
for %%A in ("%current_wallpaper%") do set "current_name=%%~nxA"
set "prev=" & set "found=" & set "next=" & set /a count=0 & set "rand="
for /f "delims=" %%F in ('dir /b /a:-d /o:-d "%smw_wallpaperPath%\*.bmp" "%smw_wallpaperPath%\*.jpg" "%smw_wallpaperPath%\*.jpeg" "%smw_wallpaperPath%\*.png" 2^>nul') do (
	set /a count+=1
	set /a r=%random% %% !count!
	if !r! EQU 0 set "rand=%smw_wallpaperPath%\%%~F"
	if not defined latest set "latest=%smw_wallpaperPath%\%%~F"
	set "last_file=%smw_wallpaperPath%\%%~F"
	if not defined found (
		if "%%F"=="%current_name%" (
			set "found=1"
		) else set "prev=%smw_wallpaperPath%\%%~F"
	) else (
		if not defined next set "next=%smw_wallpaperPath%\%%~F"
	)
)
if not defined found if defined latest set "prev=%latest%"
if not defined next if defined latest set "next=%latest%"
if not defined prev set "prev=%last_file%"
if "%rand%" == "%current_wallpaper%" set "rand=%last_file%"
if "%direction%"=="prev" set "selected_wallpaper=%prev%"
if "%direction%"=="next" set "selected_wallpaper=%next%"
if "%direction%"=="rand" set "selected_wallpaper=%rand%"
if "%direction%"=="latest" set "selected_wallpaper=%latest%"
if not defined selected_wallpaper exit /b
call :set_wallpaper
exit /b

:toggle_auto_change
:: 0关闭 1开启 
if "%smw_auto_change%"=="0" (
for /f "usebackq delims=" %%i in (`
	powershell -NoProfile -WindowStyle Hidden -Command ^
		"Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase;" ^
		"$window = New-Object System.Windows.Window;" ^
		"$window.Title = '%appNameCN%';" ^
		"$window.Width = 350; $window.Height = 180;" ^
		"$window.WindowStartupLocation = 'CenterScreen';" ^
		"$window.ResizeMode = 'NoResize';" ^
		"$stackPanel = New-Object System.Windows.Controls.StackPanel;" ^
		"$stackPanel.Margin = New-Object System.Windows.Thickness(15);" ^
		"$comboPanel = New-Object System.Windows.Controls.StackPanel;" ^
		"$comboPanel.Orientation = 'Horizontal';" ^
		"$comboPanel.HorizontalAlignment = 'Center';" ^
		"$comboPanel.Margin = '0,0,0,20';" ^
		"$label = New-Object System.Windows.Controls.Label;" ^
		"$label.Content = '更换频率：';" ^
		"$label.VerticalAlignment = 'Center';" ^
		"$label.Margin = '0,0,10,0';" ^
		"$comboBox = New-Object System.Windows.Controls.ComboBox;" ^
		"$comboBox.Width = 100; $comboBox.Height = 20;" ^
		"$options = [ordered]@{ ' 1 分钟'='00:01:00'; ' 5 分钟'='00:05:00'; '10 分钟'='00:10:00'; '15 分钟'='00:15:00'; " ^
				"'30 分钟'='00:30:00';' 1 小时'='01:00:00'; ' 3 小时'='03:00:00'; ' 6 小时'='06:00:00'; '12 小时'='12:00:00' };" ^
		"$options.Keys | ForEach-Object { $comboBox.Items.Add($_) | Out-Null };" ^
		"$comboBox.SelectedIndex = 0;" ^
		"$comboPanel.Children.Add($label) | Out-Null;" ^
		"$comboPanel.Children.Add($comboBox) | Out-Null;" ^
		"$buttonPanel = New-Object System.Windows.Controls.StackPanel;" ^
		"$buttonPanel.Orientation = 'Horizontal';" ^
		"$buttonPanel.HorizontalAlignment = 'Center';" ^
		"$buttonPanel.Margin = '0,30,0,0';" ^
		"$okButton = New-Object System.Windows.Controls.Button;" ^
		"$okButton.Content = '确定'; $okButton.Width = 80; $okButton.Margin = '0,0,20,0';" ^
		"$okButton.Add_Click({ $window.Tag = 'OK'; $window.Close() });" ^
		"$cancelButton = New-Object System.Windows.Controls.Button;" ^
		"$cancelButton.Content = '取消'; $cancelButton.Width = 80;" ^
		"$cancelButton.Add_Click({ $window.Tag = 'Cancel'; $window.Close() });" ^
		"$buttonPanel.Children.Add($okButton) | Out-Null;" ^
		"$buttonPanel.Children.Add($cancelButton) | Out-Null;" ^
		"$stackPanel.Children.Add($comboPanel) | Out-Null;" ^
		"$stackPanel.Children.Add($buttonPanel) | Out-Null;" ^
		"$window.Content = $stackPanel;" ^
		"$window.ShowDialog() | Out-Null;" ^
		"if ($window.Tag -eq 'OK') { $sel = $comboBox.SelectedItem; Write-Output $options[$sel] } else { Write-Output 'CANCELLED' }"
	`) do set "timeSpanStr=%%i"
	if /i "!timeSpanStr!"=="CANCELLED" exit /b
	::添加任务计划 
	call :print_log "添加任务计划：%autoChangeTaskName%"
	call :print_log "添加任务计划时间频率：!timeSpanStr!"
	powershell -nologo -command ^
		"$parts = '!timeSpanStr!' -split ':';"^
		"$ts = New-TimeSpan -Hours $parts[0] -Minutes $parts[1] -Seconds $parts[2];"^
		"$now = Get-Date -Format 'HH:mm';" ^
		"$trigger = New-ScheduledTaskTrigger -Once -At $now -RepetitionInterval $ts;"^
		"$action = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument '\"%vbsPath%\" next';"^
		"$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit 0;"^
		"Register-ScheduledTask -TaskName '%autoChangeTaskName%' -Trigger $trigger -Action $action -Settings $settings -Force;"
	reg add "%app_regedit%\shell\5_autoChange" /v "Icon" /t REG_SZ /d "shell32.dll,-253" /f >nul 2>&1
	set "smw_auto_change=1"
	call :show_message "已设置%autoChangeTaskName%"
) else (
	call :print_log "取消任务计划: %autoChangeTaskName%"
	schtasks /delete /tn "%autoChangeTaskName%" /F
	reg delete "%app_regedit%\shell\5_autoChange" /v "Icon" /f >nul 2>&1
	set "smw_auto_change=0"
	call :show_message "已取消%autoChangeTaskName%"
)
call :print_log "设置smw_auto_change %smw_auto_change%"
call :save_config
exit /b

:set_wallpaper
call :print_log "设置壁纸： %selected_wallpaper%"
if not exist "%selected_wallpaper%" exit /b
powershell -Command "Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public class Wallpaper { [DllImport(\"user32.dll\", CharSet=CharSet.Auto)] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'; [void][Wallpaper]::SystemParametersInfo(20, 0, '%selected_wallpaper%', 3)"
exit /b

:select_folder
for /f "usebackq delims=" %%i in (
	`powershell -noprofile -command "$shell=New-Object -ComObject Shell.Application; $folder=$shell.BrowseForFolder(0,'%~1',0,0); if($folder){$folder.Self.Path}"`
) do set "selectedFolder=%%i"
exit /b

:set_wallpaperPath
call :select_folder "请选择壁纸文件夹"
if not defined selectedFolder (
	call :print_log "未输入路径，操作已取消。"
	exit /b
)
set "smw_wallpaperPath=%selectedFolder%"
call :print_log "已设置壁纸目录：%selectedFolder%"
call :show_message "已设置壁纸目录：%selectedFolder%"
call :save_config
exit /b

:open_wallpaperPath
powershell -command "Invoke-Item -Path '%smw_wallpaperPath%'"
exit /b

:open_installDir
powershell -command "Invoke-Item -Path '%installDir%'"
exit /b


:: 下载bing壁纸 
:load_bing_wallpaper
if not exist "%smw_wallpaperPath%" mkdir "%smw_wallpaperPath%"
set "baseUrl=https://www.bing.com"
set /a bCounter=0
for /L %%i in (0,1,1) do (
	set /a index = %%i * 7
	set /a num = %%i + 7
	set "jsonUrl=!baseUrl!/HPImageArchive.aspx?format=js&idx=!index!&n=!num!&mkt=zh-CN&nc=1614319565639&pid=hp&FORM=BEHPTB&uhd=1&uhdwidth=3840&uhdheight=2160"
	for /f "usebackq tokens=1,* delims=@" %%A in (`
		powershell -nologo -command ^
			"$ErrorActionPreference = 'Stop';" ^
			"try {" ^
			"  $ProgressPreference = 'SilentlyContinue';" ^
			"  $json = Invoke-RestMethod -Uri '!jsonUrl!' -UseBasicParsing;" ^
			"  if ($null -eq $json.images -or $json.images.Count -eq 0) { exit 1 }" ^
			"  $json.images | ForEach-Object { Write-Output ('!baseUrl!' + $_.url + '@' + $_.enddate + '_' + ($_.urlbase.Substring(7))) }" ^
			"} catch { exit 1 }"
	`) do (
		set /a bCounter+=1
		set "imageUrl[!bCounter!]=%%A"
		set "imageName[!bCounter!]=%%B"
	)
)
call :print_log "获取Bing壁纸数量: %bCounter%"
if %bCounter% EQU 0 call :show_message "无可用联网壁纸" & exit /b
set /a localImages=0
set /a downloadCounter=0
for /L %%i in (!bCounter!,-1,1) do (
	set "bingImagePath=%smw_wallpaperPath%\!imageName[%%i]!.jpg"
	if not exist !bingImagePath! (
		call :print_log "下载地址：!imageUrl[%%i]!"
		call :print_log "下载文件：!imageName[%%i]!.jpg"
		call :print_log "本地地址：%smw_wallpaperPath%\!imageName[%%i]!.jpg"
		curl.exe --retry 2 --max-time 30 -so "!bingImagePath!" "!imageUrl[%%i]!"
		set "selected_wallpaper=!bingImagePath!"
		if exist !bingImagePath! set /a downloadCounter+=1
	) else set /a localImages+=1
)
call :show_message "联网壁纸%bCounter%张 本地已有%localImages%张 本次下载%downloadCounter%张"
if defined selected_wallpaper call :set_wallpaper
exit /b

:day_bing_wallpaper
:: 0关闭 1开启 
if "%smw_day_bing_wallpaper%"=="0" (
	::添加任务计划 
	call :print_log "添加任务计划：%dayBingWallpaperTaskName%"
	powershell -nologo -command ^
		"$trigger1 = New-ScheduledTaskTrigger -Daily -At 00:00;"^
		"$trigger2 = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME;"^
		"$trigger2.Delay = 'PT1M';"^
		"$action = New-ScheduledTaskAction -Execute \"wscript.exe\" -Argument '\"%vbsPath%\" load_bing_wallpaper task';"^
		"$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries;"^
		"Register-ScheduledTask -TaskName \"%dayBingWallpaperTaskName%\" -Trigger $trigger1, $trigger2 -Action $action -Settings $settings;"
	reg add "%app_regedit%\shell\6_network\shell\2_bingDayWallpaper" /v "Icon" /t REG_SZ /d "shell32.dll,-253" /f >nul 2>&1
	set "smw_day_bing_wallpaper=1"
	call :show_message "已设置每天自动下载必应壁纸"
) else (
	call :print_log "取消任务计划：%dayBingWallpaperTaskName%"
	schtasks /delete /tn "%dayBingWallpaperTaskName%" /F
	reg delete "%app_regedit%\shell\6_network\shell\2_bingDayWallpaper" /v "Icon" /f >nul 2>&1
	set "smw_day_bing_wallpaper=0"
	call :show_message "已取消每天自动下载必应壁纸"
)
call :print_log "设置smw_day_bing_wallpaper %smw_day_bing_wallpaper%"
call :save_config
exit /b

:save_config
(for %%p in (%requiredParams%) do echo %%p=!%%p!) > "%configFile%"
exit /b

:show_message
:: 任务执行的不弹框 
if not "%param[2]%"=="task" (
    start "" powershell -windowstyle hidden -command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('%~1', '%appNameCN%', 'OK', 'Information')"
)
exit /b

:print_log
if "%smw_log%"=="1" (
	echo.[%date% %time%] %~1>> %installDir%\log\smw.log
)
exit /b