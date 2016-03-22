# is_virt.rb

Facter.add("is_virt") do
    setcode do
        begin
          Facter.kernel
        rescue
          Facter.loadfacts()
        end
        kernel = Facter.value('kernel')
        if kernel.match(/Linux/)
          is_virt = Facter.value('virtual')
        elsif kernel.match(/AIX/)
	        is_virt = %x{lparstat -i | awk -F: '/Type/ { gsub(" ", ""); print $2 }'}.chomp
        else
          is_virt = "undefined"
        end
        is_virt
    end
end

# end is_virt.rb
