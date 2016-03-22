# whichpuppet.rb

Facter.add("whichpuppet") do
    setcode do
        begin
            Facter.kernel
        rescue
            Facter.loadfacts()
        end
        kernel = Facter.value('kernel')
        if kernel.match(/Linux/)
            whichpuppet = %x{which puppet}.chomp
        elsif kernel.match('AIX')
            whichpuppet = %x{which puppet}.chomp
        else
            whichpuppet = "undefined"
        end
        whichpuppet
    end
end

# end whichpuppet.rb
