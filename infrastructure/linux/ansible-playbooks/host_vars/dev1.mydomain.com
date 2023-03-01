copy_files:
  docker_config:
    src: files/dev1.mydomain.com/docker_config.json
    dest: /projects/docker/config.json
    group: docker
