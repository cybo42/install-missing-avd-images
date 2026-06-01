#!/usr/bin/env perl

use strict;
use warnings;

sub avd_dir {
  return $ENV{ANDROID_AVD_HOME} if $ENV{ANDROID_AVD_HOME};
  return "$ENV{ANDROID_EMULATOR_HOME}/avd" if $ENV{ANDROID_EMULATOR_HOME};
  return "$ENV{ANDROID_USER_HOME}/avd" if $ENV{ANDROID_USER_HOME};
  return "$ENV{HOME}/.android/avd";
}

my $avd = avd_dir();
chdir $avd or die "Could not chdir to AVD directory $avd: $!\n";
print "Using AVD directory: $avd\n";

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
    }
  }
  close $fh;
}

