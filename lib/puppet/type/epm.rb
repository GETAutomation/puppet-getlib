Puppet::Type.newtype(:epm) do
  desc <<-EOT
    EPM Package Manager Portable Package Provider for Puppet:

    EPM portable packages have the following format:
      ${package}-${version}-${::kernel}-${::kernelmajversion}-${::hardwareisa}.tar.gz

    Currently this type's provider only supports CURL for its method of transport, however new methods will be added
    as needed.

    System Tools Used by this Module:
      * curl
      * gunzip
      * tar
      _note: gunzip is used in conjunction with tar as to handle unix. gnu tar is not on every unix system._
      This will likely change for a ruby alternative at a later date.

    Examples:
        If source is http and target are epm install scripts. This expects the .install .ss .sw .remove epm scripts -
          epm { 'zabbix_agent':
            package => 'zabbix_agent',
            source  => 'http://webserver/epms/',
          }

          epm { 'zabbix_agent':
            package        => 'zabbix_agent',
            version        => '2.2.2',
            kernel         => $::kernel,
            kernel_version => $::kernelmajversion
            architecture   => $::hardwareisa.
            source         => 'http://webserver/epms/',
          }
  EOT

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:package_name, :namevar => true) do
    desc 'Package name, will default to resource name if omitted'
  end

  newparam(:version) do
    desc <<-EOT
      Optional: the version of the package you wish to install.
       If version is specified than provider assumes tarball.
       Otherwise it assumes scripts are uncompressed in the :source.
    EOT
  end

  newparam(:kernel) do
    desc 'Optional: The kernel the package is intended for. Default: Facter.value(:kernel).downcase'
    defaultto Facter.value(:kernel).downcase
  end

  newparam(:kernel_version) do
    desc 'Optional: The kernel version the package is intended for. Default: Facter.value(:kernelmajversion)'
    defaultto Facter.value(:kernelmajversion)
  end

  newparam(:architecture) do
    desc 'Optional: The architecture the package is intended for. Default: Facter.value(:hardwareisa)'
    defaultto Facter.value(:hardwareisa)
  end

  newparam(:source) do
    desc <<-EOT
      Required: The source where the epm portable packages can be found.
      Must be a source capable of satisfying a typical 'curl -s -O' command
        Example: http://webserver/epms
    EOT
  end


end
