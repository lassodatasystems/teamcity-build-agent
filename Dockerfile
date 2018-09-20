FROM jetbrains/teamcity-agent:2018.1.2

COPY install.sh /opt

RUN /opt/install.sh