# gateway.rb

Facter.add("gateway") do
    setcode do
        begin
            Facter.kernel
        rescue
            Facter.loadfacts()
        end
        kernel = Facter.value('kernel')
        if kernel.match(/Linux/)
            gateway = %x{netstat -rn | grep UG | awk '{ print $2 }'}.chomp
        elsif kernel.match(/AIX/)
	    gateway = %x{netstat -rn | grep default | awk '{ print $2 }'}.chomp
        else
            gateway = "undefined"
        end
        gateway
    end
end

# end gateway.rb
