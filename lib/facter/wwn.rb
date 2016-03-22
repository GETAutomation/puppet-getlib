# wwn.rb

Facter.add("wwn") do
    setcode do
        begin
            Facter.kernel
        rescue
            Facter.loadfacts()
        end
        kernelid = Facter.value('kernel')
        if kernelid.match(/Linux/)
		if File.exists?("/sys/class/fc_host")
			@wwn = []
			hosts = %x{ls -w1 /sys/class/fc_host}.split(/\n/)
			for host in hosts
				wwpn = [%x{cat /sys/class/fc_host/#{host}/port_name}.chomp]
				@wwn += wwpn
			end
			wwn = @wwn.uniq.each {|wwn|}.join(",")	
		end
        elsif kernelid.match(/AIX/)
		@wwn = []
		hosts = %x{lscfg | grep fcs | awk '{print $2}'}.split(/\n/)
		for host in hosts
                	wwpn = [%x{lscfg -vpl #{host} | grep -i "network address" |awk -F. '{print $14}'}.chomp]
                        @wwn += wwpn
                end
                wwn = @wwn.uniq.each {|wwn|}.join(",")
	else
            wwn = "undefined"
        end
       wwn
    end
end

# end wwn.rb
