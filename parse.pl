while(<>) {
    chomp;
    # We only care about transmissions of exactly 50 pulses
    next unless /^\s*433gpio: ([\d ]+) \-# 50\s*$/;

    # Turn the pulses into a binary string representation first, where 0 is a
    # short pulse, 1 is a long pulse, L is the footer and everything else a ?
    my $bin = '';
    foreach my $num (split /\s/, $1) {
        if ($num >= 200 && $num <= 600) {
            $bin .= '0';
        } elsif ($num > 600 && $num <= 1500) {
            $bin .= '1';
        } elsif ($num >= 10000 && $num < 20000) {
            $bin .= 'L';
        } else {
            $bin .= '?';
        }
    }

    # $bin can be printed at this point for debugging purposes

    # Only do further processing if we ended up with a valid transmission
    next if $bin !~ /^(01|10)+0L$/;
    # Chop off the footer
    $bin = substr $bin, 0, -2;
    # Simple Manchester decoding: Only take the odd bits!
    $bin =~ s/(\d)\d/\1/g;

    # Unpack the strings of 8 binary bits into hex bytes
    my @bytes = map { unpack('H*', pack('B8', $_)) } ($bin =~ m/.{8}/g);
    print join '', @bytes;
    print "\n";
}
