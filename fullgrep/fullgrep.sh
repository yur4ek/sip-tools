#!/bin/bash -e


ESC=$(printf '\033')

DEF="$ESC[39m"
RED="$ESC[91m"
GREEN="$ESC[92m"
BLUE="$ESC[94m"
MAGENTA="$ESC[95m"
CYAN="$ESC[96m"
YELLOW="$ESC[33m"

APPS="(AddQueueMember|ADSIProg|AELSub|AgentLogin|AgentRequest|AGI|AlarmReceiver|AMD|Answer|AttendedTransfer|Authenticate|BackGround|BackgroundDetect|BlindTransfer|Bridge|BridgeWait|Busy|CallCompletionCancel|CallCompletionRequest|CELGenUserEvent|ChangeMonitor|ChanIsAvail|ChannelRedirect|ChanSpy|ClearHash|ConfBridge|Congestion|ContinueWhile|ControlPlayback|DAHDIRAS|DAHDIScan|DAHDISendCallreroutingFacility|DAHDISendKeypadFacility|DateTime|DBdel|DBdeltree|DeadAGI|Dial|Dictate|Directory|DISA|DumpChan|EAGI|Echo|EndWhile|Exec|ExecIf|ExecIfTime|ExitWhile|ExtenSpy|ExternalIVR|Festival|Flash|FollowMe|ForkCDR|GetCPEID|Gosub|GosubIf|Goto|GotoIf|GotoIfTime|Hangup|HangupCauseClear|IAX2Provision|ICES|ImportVar|Incomplete|JabberJoin|JabberLeave|JabberSend|JabberSendGroup|JabberStatus|JACK|Log|Macro|MacroExclusive|MacroExit|MacroIf|MailboxExists|MessageSend|Milliwatt|MinivmAccMess|MinivmDelete|MinivmGreet|MinivmMWI|MinivmNotify|MinivmRecord|MixMonitor|Monitor|Morsecode|MP3Player|MSet|MusicOnHold|NBScat|NoCDR|NoOp|ODBC_Commit|ODBC_Rollback|ODBCFinish|Originate|Page|Park|ParkAndAnnounce|ParkedCall|PauseMonitor|PauseQueueMember|Pickup|PickupChan|Playback|PlayTones|PrivacyManager|Proceeding|Progress|Queue|QueueLog|RaiseException|Read|ReadExten|ReceiveFAX|Record|RemoveQueueMember|ResetCDR|RetryDial|Return|Ringing|SayAlpha|SayAlphaCase|SayDigits|SayNumber|SayPhonetic|SayUnixTime|SendDTMF|SendFAX|SendImage|SendText|SendURL|Set|SetAMAFlags|SIPAddHeader|SIPDtmfMode|SIPRemoveHeader|SMS|SoftHangup|SpeechActivateGrammar|SpeechBackground|SpeechCreate|SpeechDeactivateGrammar|SpeechDestroy|SpeechLoadGrammar|SpeechProcessingSound|SpeechStart|SpeechUnloadGrammar|StackPop|StartMusicOnHold|Stasis|StopMixMonitor|StopMonitor|StopMusicOnHold|StopPlayTones|System|TestClient|TestServer|Transfer|TryExec|TrySystem|UnpauseMonitor|UnpauseQueueMember|UserEvent|Verbose|VMAuthenticate|VMSayName|VoiceMail|VoiceMailMain|VoiceMailPlayMsg|Wait|WaitExten|WaitForNoise|WaitForRing|WaitForSilence|WaitUntil|While|Zapateller)"

lastcontext=""
concolor=$GREEN
while read line; do
    if echo $line|egrep -q "C-[0-9a-f]{8}] pbx.c" ; then
        head=$(echo $line|egrep -o  ^.*[0-9a-f]+\",)
        cmd=$(echo $line|sed -nr "s/^.*\", (.*)\).*$/\1/;s/([0-9]+)/$BLUE\1$DEF/g;s/([A-Z_]+|[A-Z_]+\(.*\))=/$GREEN\1$DEF=/g;p")
        context=$(echo $line| sed -r "s/^.*@([^:]+).*$/\1/")
        if [[ $context != $lastcontext ]]; then
            lastcontext=$context
            if [[ $concolor == $GREEN ]]; then
                concolor=$YELLOW
            else
                concolor=$GREEN
            fi
        fi
        line=$(echo $head$cmd | sed -r "s/\[([0-9siht~]+)@([^:]+):([0-9]+)/\[$MAGENTA\1$DEF@$concolor\2$DEF:$BLUE\3$DEF/")
    fi
    echo $line | sed -r "s/$APPS\(/$RED\1$DEF\(/g; s/(WARNING|ERROR)/$RED\1$DEF/" 
done

