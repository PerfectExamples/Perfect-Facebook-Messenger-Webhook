TGZ=/tmp/fb.tgz
RPO=fb
APP=/tmp/app.tgz
NAME=FBMsgSrv
EXE=PerfectTemplate
BLDEXEC=/tmp/$RPO/.build/release/$EXE
INST=/home/ubuntu/$NAME/$EXE
LIB=/usr/local/lib/swiftlib3.0.2.tgz
SERVER=ubuntu@cookiemonster.perfect.org
scp Sources/main.swift nut:/tmp/$RPO/Sources
ssh nut "cd /tmp;cd $RPO; swift build -c release"
scp nut:$BLDEXEC /tmp/$EXE
scp /tmp/$EXE $SERVER:$INST
echo "ssh $SERVER \"$INST\""
