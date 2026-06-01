#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;

my $delete = 0;
GetOptions("delete|d" => \$delete) or die "Usage: $0 [-d|--delete]\n";

sub avd_dir {
  return $ENV{ANDROID_AVD_HOME} if $ENV{ANDROID_AVD_HOME};
  return "$ENV{ANDROID_EMULATOR_HOME}/avd" if $ENV{ANDROID_EMULATOR_HOME};
  return "$ENV{ANDROID_USER_HOME}/avd" if $ENV{ANDROID_USER_HOME};
  return "$ENV{HOME}/.android/avd";
}

my $avd = avd_dir();
chdir $avd or die "Could not chdir to AVD directory $avd: $!\n";
print "Using AVD directory: $avd\n";

my %in_use;

print "Reading in-use system images...\n";

for my $file (glob("*/config.ini")) {
  print "Reading AVD config $file\n";
  open my $fh, "<", $file or die "Could not open $file: $!";
  while (<$fh>) {
    # Look for system images key image.sysdir.1 etc..
    if (/image\.sysdir\.\d+=(.*)\//) {
      my $package = $1;
      $package =~ s/\//;/g;
      $in_use{$package} = 1;
    }
  }
  close $fh;
}

print "\nReading installed system images from sdkmanager...\n";

my %installed;
open my $sdk, "-|", "sdkmanager --list" or die "Could not run sdkmanager: $!";
my $in_installed_section = 0;
while (<$sdk>) {
  # The output has an "Installed packages:" section followed by an
  # "Available Packages:" section. We only care about the former.
  if (/^Installed packages:/) {
    $in_installed_section = 1;
    next;
  }
  if (/^Available Packages:/ || /^Available Updates:/) {
    $in_installed_section = 0;
    next;
  }
  next unless $in_installed_section;

  # Lines look like: "  system-images;android-30;google_apis;x86_64 | 12 | ..."
  if (/^\s*(system-images;\S+)/) {
    $installed{$1} = 1;
  }
}
close $sdk;

print "\nInstalled system-images that are NOT in use:\n";
my @unused = sort grep { !$in_use{$_} } keys %installed;
if (@unused) {
  print "$_\n" for @unused;

  if ($delete) {
    print "\nUninstalling unused system-images...\n";
    for my $package (@unused) {
      print "sdkmanager --uninstall '$package'\n";
      system("sdkmanager", "--uninstall", $package) == 0
        or warn "Failed to uninstall $package\n";
    }
  }
} else {
  print "(none)\n";
}
