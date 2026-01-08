#!/usr/bin/env perl

use strict;
use warnings;

for my $file (glob("*/config.ini")) {
  print "$file\n";
  open my $fh, "<", $file or die "Could not open $file: $!";
  while (<$fh>) {
    if (/image\.sysdir\.1=(.*)\//) {
      my $package = $1;
      $package =~ s/\//;/g;
      print "Path $package\n";
      system("sdkmanager '$package'");
      last;
    }
  }
  close $fh;
}

