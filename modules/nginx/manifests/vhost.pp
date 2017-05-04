#Nginx conf setup and file creation

class nginx::vhost {

 $default_parent_root = "/home/ubuntu/nginxsites-puppet"
 $dir_tree = [ "$default_parent_root"]
 file { $dir_tree :
        owner   => 'ubuntu',
        group   => 'ubuntu',
        ensure  => 'directory',
        mode    => '777',
  }

  # Method to create website specific files and configuration for nginx
  define createwebsite($domain='UNSET',$root='UNSET') {
  	include nginx 
 
  	# Default value setup for domin and root
 
  	if $domain == 'UNSET' {	
            $vhost_domain = $name
	  } else {
	    $vhost_domain = $domain
        }
 
  	if $root == 'UNSET' {
	    	$vhost_root = "$default_parent_root/${name}"
  	} else {
    		$vhost_root = $root
	}

  # vhost.erb file in nginx/templates directory will create the nginx conf file
 
  file { "/etc/nginx/sites-available/${vhost_domain}.conf":
    content => template('nginx/vhost.erb'), 
    require => Package['nginx'],
    notify  => Exec['reload nginx'], 
  }
 
 
  file { "/etc/nginx/sites-enabled/${vhost_domain}.conf":
    ensure  => link,
    target  => "/etc/nginx/sites-available/${vhost_domain}.conf",
    require => File["/etc/nginx/sites-available/${vhost_domain}.conf"],
    notify  => Exec['reload nginx'],
  }

  addHTMLFiles{ "htmlfiles-${vhost_root}":
	
	vhost_root => $vhost_root,
        vhost_domain => $vhost_domain,

  }

}

  define addHTMLFiles( $vhost_root , $vhost_domain ){


   include nginx::systeminformation	
	

   $dir_tree = [ "$vhost_root" ]
   file { $dir_tree :
       owner   => 'ubuntu',
       group   => 'ubuntu',
       ensure  => 'directory',
       mode    => '777',
   }->   # vhost_root directory will be created first
   
   file {  ["$vhost_root/index.html"]:
       owner   => 'ubuntu',
       group   => 'ubuntu',
       source => "puppet:///modules/nginx/${vhost_domain}/index-html",
       mode    => '755',
   }->

   file { ["$vhost_root/systeminformation.html"] :
	content => template("nginx/systeminformation.erb"),
   }	
  }
}
