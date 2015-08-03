FROM fedora:21
MAINTAINER "Adam Miller" <maxamillion@fedoraproject.org>

RUN yum -y update && yum install -y sed && yum clean all

# A repo where we can find recent Cockpit builds for Fedora
ADD cockpit-preview.repo /etc/yum.repos.d/

RUN yum -y --enablerepo=cockpit-preview install cockpit-ws

# And the stuff that starts the container
ADD atomic-* /container/
RUN chmod -v +x /container/atomic-* && rm -f /etc/os-release /usr/lib/os-release && ln -sv /host/etc/os-release /etc/os-release && ln -sv /host/usr/lib/os-release /usr/lib/os-release && ln -sv /host/proc/1 /container/target-namespace

LABEL INSTALL /usr/bin/docker run -ti --rm --privileged -v /:/host IMAGE /container/atomic-install
LABEL UNINSTALL /usr/bin/docker run -ti --rm --privileged -v /:/host IMAGE /cockpit/atomic-uninstall
LABEL RUN /usr/bin/docker run -d --privileged --pid=host -v /:/host IMAGE /container/atomic-run --local-ssh

# Look ma, no EXPOSE

CMD ["/container/atomic-run"]
