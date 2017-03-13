TGZ=/tmp/fb.tgz
RPO=fb
APP=/tmp/app.tgz
NAME=FBMsgSrv
LIB=/usr/local/lib/swiftlib3.0.2.tgz
SERVER=ubuntu@cookiemonster.perfect.org
tar czvf $TGZ Package.swift Sources
scp $TGZ nut:/tmp
ssh nut "cd /tmp;rm -rf $RPO;mkdir $RPO; cd $RPO; tar xzvf $TGZ;swift build -c release;cd .build/release;tar czvf $APP PerfectTemplate *.so"
scp nut:$APP $APP
scp $APP $SERVER:$APP
ssh $SERVER "cd /home/ubuntu;rm -rf $NAME;mkdir $NAME;cd $NAME;tar xzvf $APP;tar xzvf $LIB"
echo "ssh $SERVER \"/home/ubuntu/$NAME/PerfectTemplate\""
