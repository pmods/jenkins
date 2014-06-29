include tomcat7

class jenkins {

    $jenkins_url = 'http://mirrors.jenkins-ci.org/war/latest/jenkins.war'
    $webapps_dir = '/usr/local/apache-tomcat-7.0/webapps'
    $execpath    = '/bin:/sbin:/usr/bin:/usr/sbin'

    exec { 'jenkins-fetch':
        command => "fetch $jenkins_url",
        creates => "$webapps_dir/jenkins.war",
        user    => 'www',
        group   => 'www',
        cwd     => "$webapps_dir",
        path    => $execpath,
        notify  => Class['tomcat7']
    }

    file {'jenkins-home':
        path => '/usr/local/jenkins',
        ensure => directory,
        owner => 'www',
        group => 'www',
    }
}
