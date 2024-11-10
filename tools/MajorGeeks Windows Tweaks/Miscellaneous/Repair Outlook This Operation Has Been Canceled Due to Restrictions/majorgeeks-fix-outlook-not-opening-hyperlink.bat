
@echo off
REG ADD HKEY_CURRENT_USER\Software\Classes\.htm /ve /d htmlfile /f
REG ADD HKEY_CURRENT_USER\Software\Classes\.html /ve /d htmlfile /f
REG ADD HKEY_CURRENT_USER\Software\Classes\.shtml /ve /d htmlfile /f
REG ADD HKEY_CURRENT_USER\Software\Classes\.xht /ve /d htmlfile /f
REG ADD HKEY_CURRENT_USER\Software\Classes\.xhtml /ve /d htmlfile /f
echo Registry updated successfully.
pause


