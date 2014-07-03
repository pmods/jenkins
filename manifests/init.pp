include tomcat7

class jenkins {

    $jenkins_url = 'http://mirrors.jenkins-ci.org/war/latest/jenkins.war'
    $webapps_dir = '/usr/local/apache-tomcat-7.0/webapps'
    $execpath    = '/bin:/sbin:/usr/bin:/usr/sbin'

    $jenkins_home = '/usr/local/jenkins'

    exec { 'jenkins-fetch':
        command => "fetch $jenkins_url",
        creates => "$webapps_dir/jenkins.war",
        user    => 'www',
        group   => 'www',
        cwd     => "$webapps_dir",
        path    => $execpath,
        require => Package['tomcat7'],
        notify  => Service['tomcat7']
    }

    file {'jenkins-home':
        path   => $jenkins_home,
        ensure => directory,
        owner  => 'www',
        group  => 'www',
    }

    exec { 'jenkins-home-rc':
        command => "/bin/echo tomcat7_java_opts=\"-DJENKINS_HOME=$jenkins_home/\" >> /etc/rc.conf",
        user    => 'root',
        unless  => "/usr/bin/grep tomcat7_java_opts /etc/rc.conf",
        require => File['jenkins-home'],
        notify  => Service['tomcat7']
    }
}
