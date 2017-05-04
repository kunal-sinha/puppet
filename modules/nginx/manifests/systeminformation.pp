#Systeminfo: System deatails using factors

class nginx::systeminformation {

	$systeminformationdata = [
		{
			info => $::puppetversion
		},
		{
			info => $::rubyplatform
		},
		{
			info => $::kernelmajversion
		},
		{
			info => $::kernelrelease
		},
	]

}
