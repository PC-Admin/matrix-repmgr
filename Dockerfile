# A dockerfile must always start by importing the base image.
# We use the keyword 'FROM' to do that.
# In our example, we want import the python image.
# So we write 'python' for the image name and 'latest' for the version.
FROM debian:bullseye-slim

# In order to launch our python code, we must import it into our image.
# We use the keyword 'COPY' to do that.
# The first parameter 'main.py' is the name of the file on the host.
# The second parameter '/' is the path where to put the file on the image.
# Here we put the file at the image root folder.
#COPY main.py /
RUN /usr/bin/apt update
RUN /usr/bin/apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive /usr/bin/apt install keyboard-configuration -y
RUN DEBIAN_FRONTEND=noninteractive /usr/bin/apt install repmgr dropbear openssh-client -y
RUN /usr/bin/apt install sudo net-tools inetutils-ping nano strace procps -y
COPY pg_hba.conf /etc/postgresql/13/main/
COPY postgresql.conf /etc/postgresql/13/main/
#RUN netstat -lp --protocol=unix | grep postgres
#COPY sshd_config /etc/ssh/
COPY dropbear /etc/default/
RUN mkdir /var/run/sshd
RUN mkdir /var/lib/postgresql/.ssh/
RUN groupmod -g 1000 postgres && usermod -u 997 -g 1000 postgres
RUN /bin/chmod 644 /etc/dropbear/dropbear_ed25519_host_key
#RUN /sbin/runuser -u postgres -- /usr/sbin/dropbear -Eas -p 2222 -r /etc/dropbear/dropbear_ed25519_host_key
#RUN /usr/sbin/sshd
#RUN runuser -l postgres -c "/usr/bin/pg_ctlcluster 13 main status"
#RUN runuser -l postgres -c 'createuser --help'
#RUN runuser -l postgres -c 'createuser -U postgres -h localhost -s repmgr'
#RUN runuser -l postgres -c 'createdb repmgr -O repmgr'
#RUN runuser -l postgres -c "psql ALTER USER repmgr SET search_path TO repmgr, "$user", public;"
#RUN runuser -l postgres -c "/usr/bin/pg_ctlcluster 13 main start"
#RUN /usr/bin/repmgr --help
#COPY repmgr.conf /etc/
COPY matrix-repmgr-init1.sh /


# We need to define the command to launch when we are going to run the image.
# We use the keyword 'CMD' to do that.
# The following command will execute "python ./main.py".
CMD [ "/bin/bash", "/matrix-repmgr-init1.sh" ]
#CMD [ "/usr/sbin/dropbear", "-FEas", "-p", "2222", "-r", "/etc/dropbear/dropbear_ed25519_host_key" ]

# Here is a basic Dockerfile with an ENTRYPOINT that will keep on running without getting terminated.
#ENTRYPOINT ["tail", "-f", "/dev/null"]