FROM centos/s2i-base-centos7

# This image provides a Ruby 2.4 environment you can use to run your Ruby
# applications.

EXPOSE 8080

ENV RUBY_VERSION 2.4

# To use subscription inside container yum command has to be run first (before yum-config-manager)
# https://access.redhat.com/solutions/1443553
RUN yum install -y centos-release-scl && \
    INSTALL_PKGS="libvirt systemd-devel libvirt-devel rh-ruby24 rh-ruby24-ruby-devel rh-ruby24-rubygem-rake rh-ruby24-rubygem-bundler rh-nodejs6 rh-nodejs6-npm" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Copy extra files to the image.
COPY ./root/ /

COPY ./database.yml /opt/app-root/src

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 /opt/app-root/ && chmod -R ug+rwx /opt/app-root/ && \
    rpm-file-permissions

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
