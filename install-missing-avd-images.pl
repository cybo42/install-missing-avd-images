#!/usr/bin/env perl

use strict;
use warnings;

for my $file (glob("*/config.ini")) {
  print "$file\n";
  open my $fh, "<", $file or die "Could not open $file: $!";
  while (<$fh>) {
    # Look for system images key image.sysdir.1 etc..
    if (/image\.sysdir\.\d+=(.*)\//) {
      my $package = $1;
      $package =~ s/\//;/g;
      print "Path $package\n";
      system("sdkmanager '$package'");
      last;
    }
  }
  close $fh;
}

