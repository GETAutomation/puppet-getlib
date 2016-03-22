# serial_number.rb

Facter.add("serial_number") do
  setcode do
    begin
      Facter.kernel
    rescue
      Facter.loadfacts()
    end
    kernel = Facter.value('kernel')
    if kernel.match(/Linux/)
      serial_number = Facter.value('serialnumber')
    elsif kernel.match(/AIX/)
      ser_num=%x{lsattr -El sys0 -a systemid | awk '{print $2}' | awk -F, '{print $2}'}.chomp
      prefix=%x{echo #{ser_num} | cut -c3-4}.chomp
      suffix=%x{echo #{ser_num} | cut -c5-9}.chomp
      serial_number = %x{echo #{prefix}-#{suffix}}.chomp
    else
      serial_number = "undefined"
    end
    serial_number
  end
end

# end serial_number.rb