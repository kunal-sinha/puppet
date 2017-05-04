#Class to dynamically add host files entries

class nginx::hosts( $serverdetails ) {

        file { '/etc/hosts':
            content => template('nginx/hosts.erb'),
        }

}
