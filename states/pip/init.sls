{#
 # Install python-pip, a cache for downloaded archive and a config file
 # to force root user to use the cache folder.
 #}
include:
  - ssh.client
  - git
  - mercurial

{{ salt['user.info']('root')['home'] }}/.pip:
  file:
    - directory
    - user: root
    - group: root
    - mode: 700

/var/cache/pip:
  file:
    - directory
    - user: root
    - group: root
    - mode: 700

pip-cache:
  file:
    - managed
    - name: {{ salt['user.info']('root')['home'] }}/.pip/pip.conf
    - template: jinja
    - source: salt://pip/config.jinja2
    - user: root
    - group: root
    - require:
      - file: {{ salt['user.info']('root')['home'] }}/.pip
      - file: /var/cache/pip

python-pip:
  pkg:
    - latest
    - require:
      - pkg: openssh-client
      - pkg: git
      - pkg: mercurial
      - file: pip-cache
