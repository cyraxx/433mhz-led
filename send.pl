while(<>) {
    # We want three byte hex only
    next unless /^[A-Fa-f0-9]{6}/;

    # Yes, this could be done using actual arithmetics, but converting to a
    # binary string and going character by character is just easier in perl
    my $bin = sprintf('%b', hex);
    my $out = '';
    foreach my $bit (split //, $bin) {
        $out .= '400 1200 ' if $bit eq '0';
        $out .= '1200 400 ' if $bit eq '1';
    }
    $out .= '400 12000';

    # Print out the resulting pulses for verification and also send them to pilight
    print $out . "\n";
    system 'pilight-send', '-p', 'raw', '-c', '"' . $out . '"';
}
