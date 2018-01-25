#!/bin/bash

if [ -e ~/.ssh/config ];then
    host=`cat ~/.ssh/config|grep -w Host|awk '{print $2}'`
    for i in ${host}
    do
        Host=`cat ~/.ssh/config|grep -A 2 -w ${i}|grep -w Host|awk '{print $2}'`
        HostName=`cat ~/.ssh/config|grep -A 2 -w ${i}|grep -w HostName|awk '{print $2}'`
        User=`cat ~/.ssh/config|grep -A 2 -w ${i}|grep -w User|awk '{print $2}'`
        cat>${Host}.ini<<EOF
D:"Is Session"=00000001
S:"Protocol Name"=SSH2
D:"Request pty"=00000001
S:"Shell Command"=
D:"Use Shell Command"=00000000
D:"Force Close On Exit"=00000000
D:"Forward X11"=00000000
S:"XAuthority File"=
S:"XServer Host"=127.0.0.1
D:"XServer Port"=00001770
D:"XServer Screen Number"=00000000
D:"Enforce X11 Authentication"=00000001
D:"Request Shell"=00000001
S:"Port Forward Filter"=allow,127.0.0.0/255.0.0.0,0 deny,0.0.0.0/0.0.0.0,0
S:"Reverse Forward Filter"=allow,127.0.0.1,0 deny,0.0.0.0/0.0.0.0,0
D:"Max Packet Size"=00001000
D:"Pad Password Packets"=00000001
S:"Sftp Tab Local Directory"=C:\Users\chenjiajian\Documents
S:"Sftp Tab Remote Directory"=
S:"Hostname"=${HostName}
S:"Firewall Name"=None
S:"Username"=${User}
D:"[SSH2] 端口"=00000016
S:"Password"=
D:"Session Password Saved"=00000000
S:"Key Exchange Algorithms"=gss-group1-sha1-toWM5Slw5Ew8Mqkay+al2g==,gss-gex-sha1-toWM5Slw5Ew8Mqkay+al2g==,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1
S:"Cipher List"=aes256-ctr,aes192-ctr,aes128-ctr,aes256-cbc,aes192-cbc,aes128-cbc,twofish-cbc,blowfish-cbc,3des-cbc,arcfour
S:"MAC List"=hmac-sha1,hmac-sha1-96,hmac-md5,hmac-md5-96,umac-64@openssh.com
S:"SSH2 Authentications V2"=publickey
S:"Compatibility Mode V2"=Auto Detect
S:"Compression List"=none
D:"Compression Level"=00000005
D:"GEX Minimum Size"=00000400
D:"GEX Preferred Size"=00000800
D:"Use Global Public Key"=00000001
S:"Identity Filename"=
D:"Public Key Type"=00000000
S:"GSSAPI Method"=auto-detect
S:"GSSAPI Delegation"=full
S:"GSSAPI SPN"=host@${HostName}
D:"SSH2 Common Config Version"=00000003
D:"Enable Agent Forwarding"=00000002
D:"Transport Write Buffer Size"=00000000
D:"Transport Write Buffer Count"=00000000
D:"Transport Receive Buffer Size"=00000000
D:"Transport Receive Buffer Count"=00000000
D:"Sftp Receive Window"=00000000
D:"Sftp Maximum Packet"=00000000
D:"Sftp Parallel Read Count"=00000000
D:"Preferred SFTP Version"=00000000
D:"Allow Connection Sharing"=00000000
D:"Auth Prompts in Window"=00000000
D:"Port Forward Receive Window"=00000000
D:"Port Forward Max Packet"=00000000
D:"Port Forward Buffer Count"=00000000
D:"Port Forward Buffer Size"=00000000
D:"Disable SFTP Extended Commands"=00000000
S:"Transfer Protocol Name"=SFTP
S:"Initial Directory"=
D:"ANSI Color"=00000000
D:"Color Scheme Overrides Ansi Color"=00000000
S:"Emulation"=VT100
S:"Default SCS"=B
D:"Keypad Mode"=00000000
D:"Line Wrap"=00000001
D:"Cursor Key Mode"=00000000
D:"Newline Mode"=00000000
D:"Enable 80-132 Column Switching"=00000001
D:"Enable Cursor Key Mode Switching"=00000001
D:"Enable Keypad Mode Switching"=00000001
D:"Enable Line Wrap Mode Switching"=00000001
D:"WaitForStrings Ignores Color"=00000000
D:"SGR Zero Resets ANSI Color"=00000001
D:"SCO Line Wrap"=00000000
D:"Display Tab"=00000000
S:"Display Tab String"=
B:"Window Placement"=0000002c
 2c 00 00 00 00 00 00 00 01 00 00 00 fc ff ff ff fc ff ff ff fc ff ff ff fc ff ff ff 00 00 00 00
 00 00 00 00 00 00 00 00 00 00 00 00
D:"Is Full Screen"=00000000
D:"Rows"=00000018
D:"Cols"=00000050
D:"Scrollback"=000001f4
D:"Resize Mode"=00000000
D:"Sync View Rows"=00000001
D:"Sync View Cols"=00000001
D:"Horizontal Scrollbar"=00000002
D:"Vertical Scrollbar"=00000002
S:"Color Scheme"=白 / 黑
B:"Normal Font v2"=00000060
 f3 ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 90 01 00 00 00 00 00 01 00 00 00 01 4c 00 75 00
 63 00 69 00 64 00 61 00 20 00 43 00 6f 00 6e 00 73 00 6f 00 6c 00 65 00 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 61 00 00 00
B:"Narrow Font v2"=00000060
 f3 ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 90 01 00 00 00 00 00 01 00 00 00 01 4c 00 75 00
 63 00 69 00 64 00 61 00 20 00 43 00 6f 00 6e 00 73 00 6f 00 6c 00 65 00 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 61 00 00 00
D:"Use Narrow Font"=00000000
S:"Output Transformer Name"=Default
D:"Use Unicode Line Drawing"=00000001
D:"Blinking Cursor"=00000001
D:"Cursor Style"=00000000
D:"Use Cursor Color"=00000000
D:"Cursor Color"=00000000
D:"Foreground"=00000000
D:"Background"=00ffffff
D:"Bold"=00000000
D:"Map Delete"=00000000
D:"Map Backspace"=00000000
S:"Keymap Name"=Default
S:"Keymap Filename"=
D:"Use Alternate Keyboard"=00000000
D:"Emacs Mode"=00000000
D:"Emacs Mode 8 Bit"=00000000
D:"Preserve Alt-Gr"=00000000
D:"Jump Scroll"=00000001
D:"Minimize Drawing While Jump Scrolling"=00000000
D:"Audio Bell"=00000001
D:"Visual Bell"=00000000
D:"Scroll To Clear"=00000001
D:"Close On Disconnect"=00000000
D:"Clear On Disconnect"=00000000
D:"Scroll To Bottom On Output"=00000001
D:"Scroll To Bottom On Keypress"=00000001
D:"CUA Copy Paste"=00000000
D:"Use Terminal Type"=00000000
S:"Terminal Type"=
D:"Use Answerback"=00000000
S:"Answerback"=
D:"Use Position"=00000000
D:"X Position"=00000000
D:"X Position Relative Left"=00000001
D:"Y Position"=00000000
D:"Y Position Relative Top"=00000001
D:"Local Echo"=00000000
D:"Strip 8th Bit"=00000000
D:"Shift Forces Local Mouse Operations"=00000001
D:"Ignore Window Title Change Requests"=00000000
D:"Copy Translates ANSI Line Drawing Characters"=00000000
D:"Translate Incoming CR To CRLF"=00000000
D:"Dumb Terminal Ignores CRLF"=00000000
D:"Use Symbolic Names For Non-Printable Characters"=00000000
D:"Show Chat Window"=00000002
D:"User Button Bar"=00000002
S:"User Button Bar Name"=Default
S:"User Font Map"=
S:"User Line Drawing Map"=
D:"Use Title Bar"=00000000
S:"Title Bar"=
D:"Send Initial Carriage Return"=00000001
D:"Use Login Script"=00000000
S:"Login Script V2"=
D:"Use Script File"=00000000
S:"Script Filename"=
S:"Upload Directory"=C:\Users\chenjiajian
S:"Download Directory"=C:\Users\chenjiajian\Downloads
D:"XModem Send Packet Size"=00000000
S:"ZModem Receive Command"=rz\r
D:"Start Tftp Server"=00000000
D:"Disable ZModem"=00000000
D:"ZModem Uses 32 Bit CRC"=00000000
D:"Force 1024 for ZModem"=00000000
D:"ZModem Encodes DEL"=00000001
D:"ZModem Force All Caps Filenames to Lower Case on Upload"=00000001
D:"Send Zmodem Init When Upload Starts"=00000000
S:"Log Filename"=
S:"Custom Log Message Connect"=
S:"Custom Log Message Disconnect"=
S:"Custom Log Message Each Line"=
D:"Log Only Custom"=00000000
D:"Generate Unique Log File Name When File In Use"=00000001
D:"Log Prompt"=00000000
D:"Log Mode"=00000000
D:"Start Log Upon Connect"=00000000
D:"Raw Log"=00000000
D:"Log Multiple Sessions"=00000000
D:"New Log File At Midnight"=00000000
D:"Trace Level"=00000000
D:"Keyboard Char Send Delay"=00000000
D:"Use Word Delimiter Chars"=00000000
S:"Word Delimiter Chars"=
D:"Idle Check"=00000000
D:"Idle Timeout"=0000012c
S:"Idle String"=
D:"Idle NO-OP Check"=00000000
D:"Idle NO-OP Timeout"=0000003c
D:"AlwaysOnTop"=00000000
D:"Line Send Delay"=00000005
D:"Character Send Delay"=00000000
D:"Send Scroll Wheel Events To Remote"=00000000
D:"Highlighting Style"=00000000
S:"Keyword Set"=<无>
D:"Eject Page Interval"=00000000
S:"Monitor Listen Address"=0.0.0.0:22
S:"Monitor Username"=
S:"Monitor Password"=
D:"Monitor Allow Remote Input"=00000000
D:"Disable Resize"=00000002
D:"Auto Reconnect"=00000002
B:"Page Margins"=00000020
 00 00 00 00 00 00 e0 3f 00 00 00 00 00 00 e0 3f 00 00 00 00 00 00 e0 3f 00 00 00 00 00 00 e0 3f
B:"Printer Font v2"=00000060
 f3 ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 90 01 00 00 00 00 00 00 03 02 01 31 43 00 6f 00
 75 00 72 00 69 00 65 00 72 00 20 00 4e 00 65 00 77 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 64 00 00 00
D:"Page Orientation"=00000001
D:"Paper Size"=00000001
D:"Paper Source"=00000007
S:"Printer Name"=
D:"Disable Pass Through Printing"=00000000
D:"Buffer Pass Through Printing"=00000000
D:"Force Black On White"=00000000
D:"Use Raw Mode"=00000000
D:"Printer Baud Rate"=00009600
D:"Printer Parity"=00000000
D:"Printer Stop Bits"=00000000
D:"Printer Data Bits"=00000008
D:"Printer DSR Flow"=00000000
D:"Printer DTR Flow Control"=00000001
D:"Printer CTS Flow"=00000001
D:"Printer RTS Flow Control"=00000002
D:"Printer XON Flow"=00000000
S:"Printer Port"=
D:"Use Printer Port"=00000000
D:"Use Global Print Settings"=00000001
D:"Operating System"=00000000
S:"Time Zone"=
S:"Last Directory"=
S:"Initial Local Directory"=
S:"Default Download Directory"=
D:"File System Case"=00000000
S:"File Creation Mask"=
D:"Disable Directory Tree Detection"=00000002
D:"Verify Retrieve File Status"=00000002
D:"Resolve Symbolic Links"=00000002
B:"RemoteFrame Window Placement"=0000002c
 2c 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 fc ff ff ff fc ff ff ff 00 00 00 00
 00 00 00 00 00 00 00 00 00 00 00 00
S:"Remote ExplorerFrame State"=1,-1,-1
S:"Remote ListView State"=1,1,1,0,0
S:"SecureFX Remote Tab State"=1,-1,-1
D:"Restart Data Size"=00000000
S:"Restart Datafile Path"=
D:"Max Transfer Buffers"=00000004
D:"Filenames Always Use UTF8"=00000000
D:"Use Multiple SFTP Channels"=00000000
D:"Suppress Stat On CWD"=00000000
D:"Disable MLSX"=00000000
D:"SecureFX Trace Level"=00000001
D:"SecureFX Use Control Address For Data Connections"=00000001
Z:"Port Forward Table V2"=00000000
Z:"Reverse Forward Table V2"=00000000
Z:"Sftp Drive Mappings"=00000001
 
Z:"Sftp User Mappings"=00000000
Z:"Keymap v3"=00000000
Z:"Description"=00000000
Z:"SecureFX Post Login User Commands"=00000000
Z:"SecureFX Bookmarks"=00000000
EOF
    done
else
    echo 'Not Found config file in ~/.ssh/' 
fi

zip CRT_config.zip ./*.ini
rm -f ./*.ini
