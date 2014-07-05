
class jenkins (
    $jenk_nconf_src = '/root/etc/jenkins/jenkins.server'
){

    include tomcat7
    include javadev
    include nginx

    $jenkins_url = 'http://mirrors.jenkins-ci.org/war/latest/jenkins.war'
    $webapps_dir = '/usr/local/apache-tomcat-7.0/jenkins'
    $execpath    = '/bin:/sbin:/usr/bin:/usr/sbin'

    $jenkins_home = '/usr/local/jenkins'

    $nconfdir = $nginx::nginxconfdir

    exec { 'jenkins-fetch':
        command => "fetch -o $webapps_dir/ROOT.war $jenkins_url",
        creates => "$webapps_dir/ROOT.war",
        user    => 'www',
        group   => 'www',
        cwd     => "$webapps_dir",
        path    => $execpath,
        require => File['jenkappdir'],
        notify  => Service['tomcat7']
    }

    file { 'jenkins-home':
        path   => $jenkins_home,
        ensure => directory,
        owner  => 'www',
        group  => 'www',
    }

    file { 'jenkins-nginxcfg':
        path    => "$nconfdir/jenkins.server",
        ensure  => file,
        owner   => 'root',
        group   => 'wheel',
        source  => $jenk_nconf_src,
        require => File['nginx-confd'],
        notify  => Service['nginx']
    }

    exec { 'jenkins-home-rc':
        command => "/bin/echo tomcat7_java_opts=\"-DJENKINS_HOME=$jenkins_home/\" >> /etc/rc.conf",
        user    => 'root',
        unless  => "/usr/bin/grep tomcat7_java_opts /etc/rc.conf",
        require => File['jenkins-home'],
        notify  => Service['tomcat7']
    }
}
