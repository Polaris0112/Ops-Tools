#!/bin/bash

if [ -e ~/.ssh/config ];then
    #echo 1
    host=`cat ~/.ssh/config|grep -w Host|awk '{print $2}'`
    for i in ${host}
    do 
        #echo ${i}
        Host=`cat ~/.ssh/config|grep -A 2 -w ${i}|grep -w Host|awk '{print $2}'`
        HostName=`cat ~/.ssh/config|grep -A 2 -w ${i}|grep -w HostName|awk '{print $2}'`
        User=`cat ~/.ssh/config|grep -A 2 -w ${i}|grep -w User|awk '{print $2}'`
        #echo ${Host},${HostName},${User} 
        cat>${Host}.xsh<<EOF
[CONNECTION:PROXY]
Proxy=
StartUp=0
[CONNECTION:SERIAL]
BaudRate=6
StopBits=0
FlowCtrl=0
Parity=0
DataBits=3
ComPort=0
[SessionInfo]
Version=5.2
Description=Xshell session file
[TRACE]
SockConn=1
SshLogin=0
SshTunneling=0
TelnetOptNego=0
[CONNECTION:SSH]
LaunchAuthAgent=1
KeyExchange=
ForwardToXmanager=1
Compression=0
KeyExchangeList=ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
NoTerminal=0
CipherList=aes128-cbc,3des-cbc,blowfish-cbc,cast128-cbc,arcfour,aes192-cbc,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes256-cbc,rijndael128-cbc,rijndael192-cbc,rijndael256-cbc,aes256-ctr,aes192-ctr,aes128-ctr,rijndael-cbc@lysator.liu.se,arcfour128,arcfour256
UseAuthAgent=0
MAC=
InitRemoteDirectory=
ForwardX11=0
VexMode=0
Cipher=
Display=localhost:0.0
FwdReqCount=0
InitLocalDirectory=
MACList=hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1,hmac-sha1-96,hmac-md5,hmac-md5-96,hmac-ripemd160,hmac-ripemd160@openssh.com,hmac-sha1-96-etm@openssh.com,hmac-md5-etm@openssh.com,hmac-md5-96-etm@openssh.com
[USERINTERFACE]
NoQuickButton=0
QuickCommand=
[CONNECTION:FTP]
Passive=1
InitRemoteDirectory=
InitLocalDirectory=
[TRANSFER]
FolderMethod=0
DropXferHandler=2
XmodemUploadCmd=rx
ZmodemUploadCmd=rz -E
FolderPath=
YmodemUploadCmd=rb -E
AutoZmodem=1
SendFolderPath=
DuplMethod=0
XYMODEM_1K=0
[CONNECTION]
PasteDelay=0
Port=22
Host=${HostName}
Protocol=SSH
AutoReconnect=0
AutoReconnectLimit=0
Description=
AutoReconnectInterval=30
FtpPort=21
UseNaglesAlgorithm=0
IPV=0
[TERMINAL]
Rows=24
CtrlAltIsAltGr=1
InitOriginMode=0
InitReverseMode=0
DisableBlinkingText=0
CodePage=65001
InitAutoWrapMode=1
Cols=80
InitEchoMode=0
Type=xterm
DisableAlternateScreen=0
CJKAmbiAsWide=0
ScrollBottomOnKeyPress=0
DisableTitleChange=0
ForceEraseOnDEL=0
InitInsertMode=0
ShiftForcesLocalUseOfMouse=1
FontLineCharacter=1
ScrollbackSize=1024
InitCursorMode=0
BackspaceSends=2
UseAltAsMeta=0
UseInitSize=0
AltKeyMapPath=
DeleteSends=0
DisableTermPrinting=0
IgnoreResizeRequest=1
ScrollBottomOnTermOutput=1
FontPowerLine=1
ScrollErasedText=1
KeyMap=0
RecvLLAsCRLF=0
EraseWithBackgroundColor=1
InitNewlineMode=0
InitKeypadMode=0
TerminalNameForEcho=Xshell
[TERMINAL:WINDOW]
ColorScheme=XTerm
LineSpace=0
CursorColor=65280
CursorBlinkInterval=600
TabColorType=0
CursorAppearance=0
TabColorOther=0
FontSize=10
CursorBlink=0
BoldMethod=2
CursorTextColor=0
FontFace=DejaVu Sans Mono
CharSpace=0
MarginBottom=5
MarginLeft=5
MarginTop=5
MarginRight=5
[CONNECTION:TELNET]
XdispLoc=1
NegoMode=0
Display=:0.0
[CONNECTION:AUTHENTICATION]
Library=0
Passphrase=
Delegation=0
UseInitScript=0
TelnetLoginPrompt=ogin:
Password=
RloginPasswordPrompt=assword:
UseExpectSend=0
TelnetPasswordPrompt=assword:
ExpectSend_Count=0
Method=1
ScriptPath=
UserKey=id_rsa
UserName=${User}
[LOGGING]
FilePath=%n_%Y-%m-%d_%t.log
Overwrite=1
TermCode=0
AutoStart=0
Timestamp=0
Prompt=0
[CONNECTION:RLOGIN]
TermSpeed=38400
[CONNECTION:KEEPALIVE]
SendKeepAliveInterval=60
KeepAliveInterval=60
TCPKeepAlive=0
KeepAliveString=
SendKeepAlive=0
KeepAlive=1
EOF
    done
else
    echo 'Not Found config file in ~/.ssh/'
fi

zip xshell_config.zip ./*.xsh
rm -f ./*.xsh

