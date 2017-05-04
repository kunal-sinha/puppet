#Entry point for Puppet

node default {
   
    nginx::vhost::createwebsite{"site1":
         domain => 'site1.assignment3.puppet.kunal.in',
         root => '/home/ubuntu/site1'
    }

    nginx::vhost::createwebsite{"site2":
         domain => 'site2.assignment3.puppet.kunal.in',
         root => '/home/ubuntu/site2'
    }

    $servers = [
	{
	  ip_address => '127.0.0.1',
          hostname => 'site1.assignment3.puppet.kunal.in'	
	},
	{
	  ip_address => '127.0.0.1',
	  hostname => 'site2.assignment3.puppet.kunal.in'
	},
    ]

    class { 'nginx::hosts':
	  serverdetails => $servers
    }

} 
