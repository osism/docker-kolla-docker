{% extends parent_template %}

{% set base_apt_keys_append = ['CFFB779AADC995E4F350A060505D97A41C61B9CD', '0A9AF2115F4687BD29803A206B73A36E6026DFCA'] %}

{% block base_header %}
COPY apt_preferences.{{ base_distro }} /etc/apt/preferences
{% endblock %}

{% set kolla_toolbox_packages_append = ['iputils-ping', 'tcpdump', 'netcat-openbsd', 'traceroute'] %}

{% set cinder_volume_packages_append = ['multipath-tools'] %}

{% set nova_compute_packages_append = ['xfsprogs'] %}

{% set horizon_packages_append = ['locales', 'tzdata'] %}

{% block elasticsearch_header %}
# On systemd-based distributions, the installation scripts will attempt to set
# kernel parameters (e.g., vm.max_map_count); you can skip this by setting the
# environment variable ES_SKIP_SET_KERNEL_PARAMETERS to true.
ENV ES_SKIP_SET_KERNEL_PARAMETERS true

ENV PATH /usr/share/elasticsearch/bin:$PATH

# NOTE(berendt): install jre before elasticsearch because of https://github.com/elastic/elasticsearch/issues/31845
#                this will solve the "subprocess new pre-installation script returned error exit status 1" issue
RUN apt-get update ${"\\"}
    && apt-get -y install --no-install-recommends default-jre-headless ${"\\"}
    && apt-get clean ${"\\"}
    && rm -rf /var/lib/apt/lists/*
{% endblock %}

{% block kibana_header %}
ENV PATH /usr/share/kibana/bin:$PATH
{% endblock %}

{% block keystone_footer %}
RUN apt-get update ${"\\"}
    && apt-get -y install --no-install-recommends ${"\\"}
           libapache2-mod-auth-openidc ${"\\"}
    && apt-get clean ${"\\"}
    && rm -rf /var/lib/apt/lists/* ${"\\"}
    && a2enmod auth_openidc
{% endblock %}

{% block skydive_install %}
RUN curl -o /usr/bin/skydive -L "https://github.com/skydive-project/skydive/releases/download/v${infrastructure_projects['skydive']}/skydive" ${"\\"}
    && chmod +x /usr/bin/skydive
{% endblock %}

# NOTE(berendt): This is a workaround for the missing footer block in the base images

{% block footer %}
RUN rm -rf /usr/share/doc/* ${"\\"}
    && rm -rf /usr/share/man/*

LABEL "io.osism.version"="${osism_version}" ${"\\"}
      "io.osism.openstack"="${openstack_version}" ${"\\"}
      "io.osism.docker_kolla_docker"="${hash_docker_kolla_docker}" ${"\\"}
      "io.osism.kolla"="${hash_kolla}" ${"\\"}
      "io.osism.release"="${hash_release}" ${"\\"}
      "org.opencontainers.image.created"="${created}" ${"\\"}
      "org.opencontainers.image.licenses"="ASL 2.0" ${"\\"}
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH" ${"\\"}
      "org.opencontainers.image.version"="${osism_version}" ${"\\"}
      "org.opencontainers.image.documentation"="https://docs.osism.io" ${"\\"}
      "org.opencontainers.image.url"="https://www.osism.de" ${"\\"}
      "org.opencontainers.image.source"="https://github.com/osism/docker-kolla-docker"
{% endblock %}

{% block base_footer %}
LABEL "io.osism.version"="${osism_version}" ${"\\"}
      "io.osism.openstack"="${openstack_version}" ${"\\"}
      "io.osism.docker_kolla_docker"="${hash_docker_kolla_docker}" ${"\\"}
      "io.osism.kolla"="${hash_kolla}" ${"\\"}
      "io.osism.release"="${hash_release}" ${"\\"}
      "org.opencontainers.image.created"="${created}" ${"\\"}
      "org.opencontainers.image.licenses"="ASL 2.0" ${"\\"}
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH" ${"\\"}
      "org.opencontainers.image.version"="${osism_version}" ${"\\"}
      "org.opencontainers.image.documentation"="https://docs.osism.io" ${"\\"}
      "org.opencontainers.image.url"="https://www.osism.de" ${"\\"}
      "org.opencontainers.image.source"="https://github.com/osism/docker-kolla-docker"
{% endblock %}

% for project in ("openstack", "openvswitch", "redis", "skydive", "aodh", "ceilometer", "cinder", "cloudkitty", "designate", "glance", "gnocchi", "heat", "keystone", "magnum", "manila", "mistral", "neutron", "nova", "novajoin", "octavia", "panko", "watcher", "barbican", "swift", "trove", "senlin", "placement"):

{% block ${project}_base_footer %}
LABEL "io.osism.version"="${osism_version}" ${"\\"}
      "io.osism.openstack"="${openstack_version}" ${"\\"}
      "io.osism.docker_kolla_docker"="${hash_docker_kolla_docker}" ${"\\"}
      "io.osism.kolla"="${hash_kolla}" ${"\\"}
      "io.osism.release"="${hash_release}"  ${"\\"}
      "org.opencontainers.image.created"="${created}" ${"\\"}
      "org.opencontainers.image.licenses"="ASL 2.0" ${"\\"}
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH" ${"\\"}
      "org.opencontainers.image.version"="${osism_version}" ${"\\"}
      "org.opencontainers.image.documentation"="https://docs.osism.io" ${"\\"}
      "org.opencontainers.image.url"="https://www.osism.de" ${"\\"}
      "org.opencontainers.image.source"="https://github.com/osism/docker-kolla-docker"
{% endblock %}
% endfor