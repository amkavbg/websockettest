#!/bin/bash

echo "Start script"

export DMCDIR="$1"

DMCED=$DMCDIR"examples/"
HTMLD=$DMCDIR"examples/"

DMODAVAF="/etc/apache2/mods-available"
DHTMLF="/var/www/html"
DMODF="/usr/lib/apache2/modules"

MWS="mod_websocket.so"
MWSDRAFT="mod_websocket_draft76.so"
MWSDINC="mod_websocket_dumb_increment.so"
MWSECHO="mod_websocket_echo.so"

echo "Copy *.so files"
cp $DMCDIR$MWS $DMODF
cp $DMCDIR$MWSDRAFT $DMODF
cp $DMCED$MWSDINC $DMODF
cp $DMCED$MWSECHO $DMODF

echo "Copy html"

cp $HTMLD"client.html" $DHTMLF
cp $HTMLD"increment.html" $DHTMLF

echo "Add param to apache configure dir"

cd $DMODAVAF

WSC="websocket.conf"
touch $WSC
cat > $WSC << EOL
<IfModule mod_socket.c>
<Location /echo>
SetHandler websocket-handler
WebSocketHandler /usr/lib/apache2/modules/mod_websocket_echo.so echo_init
</Location>
<Location /dumb-increment>
SetHandler websocket-handler
WebSocketHandler /usr/lib/apache2/modules/mod_websocket_dumb_increment.so dumb_increment_init
</Location>
</IfModule>
EOL

WSL="websocket.load"
cd $DMODAVAF
touch $WSL
cat > $WSL << EOL
LoadModule websocket_module /usr/lib/apache2/modules/mod_websocket.so
EOL

WSDL="websocket_draft76.load"
cd $DMODAVAF
touch $WSDL
cat > $WSDL << EOL
LoadModule websocket_draft76_module /usr/lib/apache2/modules/mod_websocket_draft76.so
EOL

WSDC="websocket_draft76.conf"
cd $DMODAVAF
touch $WSDC
cat > $WSDC << EOL
<IfModule mod_websocket_draft76.c>
<Location /echo>
SetHandler websocket-handler
WebSocketHandler /usr/lib/apache2/modules/mod_websocket_echo.so echo_init
SupportDraft75 On
</Location>
<Location /dumb-increment>
SetHandler websocket-handler
WebSocketHandler /usr/lib/apache2/modules/mod_websocket_dumb_increment.so dumb_increment_init
SupportDraft75 On
</Location>
</IfModule>
EOL

echo "a2enmod module"
a2enmod websocket
a2enmod websocket_draft76
echo "Restart APACHE"
service apache2 restart
echo "Script work done"

