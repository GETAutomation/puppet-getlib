require 'uri'
require 'fileutils'

Puppet::Type.type(:epm).provide(:url) do
  desc "URL Support for EPMs Portables"

  def create
    install_epm
    clean_up_installation_files
  end


  def destroy
    Dir.chdir('/etc/software')
    system("./#{resource[:package_name]}.remove now > /dev/null")
  end


  def exists?
    check_if_epm_is_installed(resource[:package_name])
  end


  private
  def check_for_epm_repository
    system("ping -c 1 #{URI.parse(resource[:source]).host} > /dev/null")
  end


  def check_if_epm_is_installed(package)
    File.exists?("/etc/software/#{package}.remove")
  end


  def clean_up_installation_files
    package = resource[:package_name]
    Dir.chdir('/var/tmp')
    FileUtils.rm( construct_package_name ) if determine_package_type == 'tarball'
    ["#{package}.install", "#{package}.remove", "#{package}.ss", "#{package}.sw"].each do |pkg|
      FileUtils.rm(pkg)
    end
  end


  def construct_package_name
    if Facter.value(:kernel) == 'AIX'
      kernel_release = resource[:kernel_version][0] + '.' + resource[:kernel_version][1]
    else
      kernel_release = resource[:kernel_version]
    end
    return "#{resource[:package_name]}-#{resource[:version]}-#{resource[:kernel]}-#{kernel_release}-#{resource[:architecture]}.tar.gz"
  end


  def determine_package_type
    return 'tarball' if resource[:version]
    return 'scripts'
  end


  def extract_tarball
    Dir.chdir('/var/tmp')
    system("gunzip < #{construct_package_name} | tar -xf -")
  end


  def make_install_executable
    Dir.chdir('/var/tmp')
    FileUtils.chmod 555, "#{resource[:package_name]}.install"
  end


  def install_epm
    Dir.chdir('/var/tmp')
    if determine_package_type == 'tarball'
      retrieve_epm_tarball
      return false unless extract_tarball
    else
      retrieve_epm_scripts
    end
    install_now
  end


  def install_now(package = resource[:package_name])
    Dir.chdir('/var/tmp')
    make_install_executable
    system("./#{package}.install now > /dev/null")
  end


  def retrieve_epm_scripts(package = resource[:package_name])
    return false unless check_for_epm_repository
    Dir.chdir('/var/tmp')
    system("curl -s -O \"#{resource[:source]}/{#{package}.install,#{package}.remove,#{package}.ss,#{package}.sw}\" > /dev/null")
  end


  def retrieve_epm_tarball(package = construct_package_name)
    return false unless check_for_epm_repository
    Dir.chdir('/var/tmp')
    system("curl -s -O #{resource[:source]}/#{package} > /dev/null")
  end


end