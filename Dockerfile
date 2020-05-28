FROM cyberark/conjur-kubernetes-authenticator

USER root

# setup rpms and main script
COPY ./*.rpm /tmp/
COPY ./start_secret_grabber.sh ./wrapper.sh /

# Install debug tools and summon
RUN rpm -i /tmp/*.rpm &&\
    chmod 755 start_secret_grabber.sh &&\
    chmod 755 wrapper.sh 

ENTRYPOINT sh -c ./wrapper.sh
