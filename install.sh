install -d /usr/share/dush
install -d /usr/share/dush/stretch
install -d /usr/share/dush/jessie
install stretch/Dockerfile /usr/share/dush/stretch/
install jessie/Dockerfile /usr/share/dush/jessie/
install create_dush.sh /usr/bin/
install dush.sh /usr/bin/
