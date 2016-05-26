package 'docker'

package 'docker-machine'

package 'docker-machine-driver-xhyve'
execute 'sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve'
execute 'sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve'

package 'docker-compose'
